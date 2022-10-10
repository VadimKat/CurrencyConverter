//
//  CurrencyType.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import Foundation

enum CurrencyType: Int, CaseIterable, Identifiable {
    case euro
    case dollar
    case yen
    
    var id: String { "\(self)" }
    
    var abbriviation: String {
        switch self {
        case .euro: return "EUR"
        case .dollar: return "USD"
        case .yen: return "JPY"
        }
    }
    
    static func getCurrencyType(by literal: String) -> CurrencyType {
        CurrencyType.allCases.first(where: { $0.abbriviation == literal }) ?? .dollar
    }
}
