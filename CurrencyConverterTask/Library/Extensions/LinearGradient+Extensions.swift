//
//  LinearGradient+Extensions.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static let customBlueGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [.customDarkBlue, .customBlue]),
                                                          startPoint: .bottomLeading,
                                                          endPoint: .topTrailing)
}
