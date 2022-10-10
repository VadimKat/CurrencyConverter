//
//  CustomNavigationBar.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    @Binding var isLoading: Bool
    
    var body: some View {
        Rectangle()
            .fill(LinearGradient.customBlueGradient)
            .frame(height: 84)
            .overlay(titleView, alignment: .bottom)
            .overlay(activityIndicator, alignment: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    private var titleView: some View {
        Text(title)
            .foregroundColor(Color.white)
            .padding(.bottom, 10)
    }
    
    @ViewBuilder private var activityIndicator: some View {
        if isLoading {
            ActivityIndicator(isAnimating: .constant(true), color: .white, style: .medium)
                .padding(.bottom, 10)
                .padding(.trailing, 20)
        }
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigationBar(title: "Currency converter", isLoading: .constant(true))
            Spacer()
        }
    }
}


