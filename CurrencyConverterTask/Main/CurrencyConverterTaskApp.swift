//
//  CurrencyConverterTaskApp.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import SwiftUI

@main
struct CurrencyConverterTaskApp: App {
    var body: some Scene {
        WindowGroup {
            ConverterView(viewModel: ConverterViewModel())
        }
    }
}
