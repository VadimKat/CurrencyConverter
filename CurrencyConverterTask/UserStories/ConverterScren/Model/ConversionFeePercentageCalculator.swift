//
//  ConversionFeePercentageCalculator.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 10.10.2022.
//

import Foundation

struct ConversionFeePercentageCalculator {
    let feePercentage: Float
    
    init(numberOfConversions: Int) {
        switch numberOfConversions {
        case 0...4: feePercentage = 0
        default: feePercentage = 0.07
        }
    }
}
