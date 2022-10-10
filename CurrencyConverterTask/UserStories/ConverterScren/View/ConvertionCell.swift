//
//  ConvertionCell.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import SwiftUI

extension ConvertionCell {
    enum ConvertionType {
        case sell
        case receive
        
        var operationName: String {
            switch self {
            case .sell: return "Sell"
            case .receive: return "Receive"
            }
        }
        
        var operationImage: some View {
            switch self {
            case .sell:
                return Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(Color.red)
                    .font(.largeTitle)
                
            case .receive:
                return Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(Color.green)
                    .font(.largeTitle)
            }
        }
    }
}

struct ConvertionCell: View {
    let convertionType: ConvertionType
    @Binding var convertionValue: Float
    @Binding var convertionCurrency: CurrencyType
    @Binding var isNeedToMarkConvertedResult: Bool
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        HStack {
            convertionType.operationImage
            Text(convertionType.operationName)
            Spacer()
            textfieldView
            menuView
        }
    }
    
    @ViewBuilder private var textfieldView: some View {
        if convertionType == .receive {
            if convertionValue > 0,
               let formatterValue = numberFormatter.string(for: convertionValue) {
                Text("+ \(formatterValue)")
                    .foregroundColor(Color.green)
            } else {
                Text("0.00")
            }
        } else {
            TextField("0.00", value: $convertionValue, formatter: numberFormatter)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
        }
    }
    
    private var menuView: some View {
        Menu {
            ForEach(CurrencyType.allCases) { currency in
                Button(action: { convertionCurrency = currency }) {
                    Text(currency.abbriviation)
                }
            }
        } label: {
            HStack(spacing: 2) {
                Text(convertionCurrency.abbriviation)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .foregroundColor(Color.black)
            .frame(width: 50)
        }
    }
}

struct ConvertionCell_Previews: PreviewProvider {
    static var previews: some View {
        ConvertionCell(convertionType: .sell, convertionValue: .constant(0), convertionCurrency: .constant(.euro), isNeedToMarkConvertedResult: .constant(false))
    }
}
