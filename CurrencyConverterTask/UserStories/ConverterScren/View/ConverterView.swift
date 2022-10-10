//
//  ConverterView.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import SwiftUI

extension ConverterView {
    enum FeedbackToUser: Identifiable {
        case error(String)
        case successfullConvertion
        
        var id: String { "\(self)" }
    }
}

struct ConverterView: View {
    @ObservedObject var viewModel: ConverterViewModel
    @State private var feedbackToUser: FeedbackToUser?
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            myBalancesHeaderView
            myBalancesView
            currencyExchangeHeaderView
            currencyExchangeView
            Spacer()
            submitButton
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.white.onTapGesture(perform: hideKeyboard))
        .alert(item: $feedbackToUser, content: alertView)
        .onReceive(viewModel.conversionDoneSignal) { feedbackToUser = .successfullConvertion }
        .onReceive(viewModel.$error) { error in
            guard let error = error else { return }
            feedbackToUser = .error(error.localizedDescription)
        }
    }
    
    private var navigationBar: some View {
        CustomNavigationBar(title: "Currency converter", isLoading: $viewModel.isLoading)
    }
    
    private var myBalancesHeaderView: some View {
        headerView(title: "My balances")
            .padding(.top, 30)
    }
    
    private var myBalancesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.orderedUserBalance, id: \.self.key) { key, value in
                    if let currency = numberFormatter.string(for: value) {
                        Text("\(currency) \(key.abbriviation)")
                            .bold()
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 40)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var currencyExchangeHeaderView: some View {
        headerView(title: "Currency exchange")
            .padding(.top, 50)
    }
    
    private var currencyExchangeView: some View {
        VStack {
            ConvertionCell(convertionType: .sell, convertionValue: $viewModel.sellValue, convertionCurrency: $viewModel.sellCurrency, isNeedToMarkConvertedResult: .constant(false))
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.leading, 65)
            
            ConvertionCell(convertionType: .receive, convertionValue: $viewModel.receiveValue, convertionCurrency: $viewModel.receiveCurrency, isNeedToMarkConvertedResult: $viewModel.isNeedToMarkConvertedResult)
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.leading, 65)
        }
        .padding(.top, 30)
    }
    
    private var submitButton: some View {
        Button(action: {
            hideKeyboard()
            viewModel.convert()
        }) {
            Capsule()
                .fill(LinearGradient.customBlueGradient)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 2, y: 2)
                .frame(height: 48)
                .overlay(Text("Submit".uppercased())
                    .font(.callout)
                    .foregroundColor(Color.white))
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
        }
        .disabled(!viewModel.isConvertButtonEnabled)
        .opacity(viewModel.isConvertButtonEnabled ? 1 : 0.6)
    }
    
    private func headerView(title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.callout)
                .foregroundColor(Color.gray)
                .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    private func alertView(feedback: FeedbackToUser) -> Alert {
        switch feedback {
        case let .error(description):
            return Alert(title: Text("Error"), message: Text(description), dismissButton: .default(Text("OK")))
        case .successfullConvertion:
            let feeString = viewModel.conversionFee > 0 ? "Comission Fee - \(viewModel.conversionFee)" : ""
            return Alert(title: Text("Currency converted"),
                         message: Text("You have converted \(String(format: "%.2f", viewModel.sellValue)) \(viewModel.sellCurrency.abbriviation) to \(String(format: "%.2f", viewModel.receiveValue)) \(viewModel.receiveCurrency.abbriviation). \(feeString)"),
                         dismissButton: .default(Text("Done"),
                                                 action: viewModel.clearAfterConversion))
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(viewModel: ConverterViewModel())
    }
}
