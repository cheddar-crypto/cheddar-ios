//
//  UserDefaults.swift
//  wallet
//
//  Created by Michael Miller on 9/13/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

enum GlobalSettings {
    @UserDefault("price", defaultValue: Price(usd: 0.0)) static var price: Price
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data,
                let user = try? JSONDecoder().decode(T.self, from: data) {
                return user

            }
            return  defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
