//
//  ConverterViewModel.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import Foundation
import Combine

class ConverterViewModel: ObservableObject {
    @Published var sellValue: Float = 0
    @Published var sellCurrency: CurrencyType = .euro
    @Published var receiveValue: Float = 0
    @Published var receiveCurrency: CurrencyType = .dollar
    @Published var userBalance: [CurrencyType : Float]
    @Published var numberOfConversions: Int = 0
    @Published var conversionFee: Float = 0
    @Published var isNeedToMarkConvertedResult: Bool = false
    @Published var orderedUserBalance: [(key: CurrencyType, value: Float)] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var isConvertButtonEnabled: Bool = false
    
    let conversionDoneSignal = PassthroughSubject<Void, Never>()
    
    let networkManager: ConverterNetworkManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkManager: ConverterNetworkManagerProtocol = ConverterNetworkManager()) {
        self.networkManager = networkManager
        
        var balance: [CurrencyType : Float] = Dictionary(uniqueKeysWithValues: CurrencyType.allCases.map { ($0, 0) })
        balance[.euro] = 1000
        self.userBalance = balance
        
        setupBindings()
    }
    
    private func setupBindings() {
        $userBalance
            .map { $0.sorted(by: { $0.key.rawValue < $1.key.rawValue }) }
            .assignWeak(to: \.orderedUserBalance, on: self)
            .store(in: &subscriptions)
        
        Publishers.CombineLatest($sellValue, $receiveValue)
            .map { $0 != $1 && $1 > 0 }
            .assignWeak(to: \.isNeedToMarkConvertedResult, on: self)
            .store(in: &subscriptions)
        
        Publishers.CombineLatest3($sellValue, $sellCurrency, $receiveCurrency)
            .filter {_sellValue, _, _ in _sellValue > 0  }
            .throttle(for: 1.5, scheduler: RunLoop.main, latest: true)
            .sink {[weak self] in
                self?.calculateCurrency(sellValue: $0, sellCurrency: $1, receiveCurrency: $2)
            }
            .store(in: &subscriptions)
        
        Publishers.CombineLatest($isLoading, $sellValue)
            .map { !$0 && $1 > 0 }
            .assignWeak(to: \.isConvertButtonEnabled, on: self)
            .store(in: &subscriptions)
    }
    
    func convert() {
        guard sellCurrency != receiveCurrency else {
            error = ConvertionError.sameCurrency
            return
        }
        
        guard sellValue > 0 else { return }
        
        guard let userBalanceForCurrency = userBalance[sellCurrency] else { return }
        let conversionPercentage = ConversionFeePercentageCalculator(numberOfConversions: numberOfConversions).feePercentage
        let fee = sellValue * conversionPercentage
        let withdrawSumm = sellValue + fee
        
        guard withdrawSumm <= userBalanceForCurrency else {
            error = ConvertionError.wrongBalance
            return
        }
        
        userBalance[sellCurrency] = userBalanceForCurrency - withdrawSumm
        userBalance[receiveCurrency] = receiveValue
        conversionFee = fee
        numberOfConversions += 1
        conversionDoneSignal.send(())
    }
    
    func clearAfterConversion() {
        sellValue = 0
        receiveValue = 0
    }
  
    private func calculateCurrency(sellValue: Float, sellCurrency: CurrencyType, receiveCurrency: CurrencyType) {
        isLoading = true
        networkManager.exchangeCurrency(sellValue: sellValue, sellCurrency: sellCurrency, receiveCurrency: receiveCurrency)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.isLoading = false
                switch completion {
                case let .failure(error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: {[weak self] response in
                self?.receiveValue = response.amount
            })
            .store(in: &subscriptions)
    }
    
    
}
