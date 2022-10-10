//
//  ConvertionError.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 10.10.2022.
//

import Foundation

enum ConvertionError: LocalizedError {
    case unknownError
    case sameCurrency
    case wrongBalance
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "Unknown error has occured. Please, try again later."
        case .sameCurrency: return "Please, choose difference currency to perform conversion"
        case .wrongBalance: return "Unable to complete operation: not enough funds"
        }
    }
}
