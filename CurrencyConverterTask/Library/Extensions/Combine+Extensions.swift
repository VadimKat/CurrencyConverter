//
//  Combine+Extensions.swift
//  CurrencyConverterTask
//
//  Created by Vadim Katenin on 07.10.2022.
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {

    func assignWeak<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root?) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

