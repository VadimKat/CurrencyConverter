//
//  –°urrencyReponseModel.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import Foundation

struct –°urrencyReponseModel: Decodable {
    let currency: CurrencyType
    var amount: Float
    
    enum CodingKeys: String, CodingKey {
        case currency
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.currency = CurrencyType.getCurrencyType(by: currency)
        let amount = try values.decodeIfPresent(String.self, forKey: .amount) ?? "0"
        self.amount = Float(amount) ?? 0
    }
}
