//
//  ConverterNetworkManager.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 10.10.2022.
//

import Foundation
import Combine

protocol ConverterNetworkManagerProtocol {
    func exchangeCurrency(sellValue: Float, sellCurrency: CurrencyType, receiveCurrency: CurrencyType) -> AnyPublisher<–°urrencyReponseModel, Error>
}

class ConverterNetworkManager: ConverterNetworkManagerProtocol {
    
     func exchangeCurrency(sellValue: Float, sellCurrency: CurrencyType, receiveCurrency: CurrencyType) -> AnyPublisher<–°urrencyReponseModel, Error> {
         let urlString = Constants.baseURL + "currency/commercial/exchange/\(sellValue)-\(sellCurrency.abbriviation)/\(receiveCurrency.abbriviation)/latest"
        guard let url = URL(string: urlString) else { return Fail(error: ConvertionError.unknownError).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: –°urrencyReponseModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
