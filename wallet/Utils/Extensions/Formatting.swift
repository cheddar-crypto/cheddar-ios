//
//  Formatting.swift
//  wallet
//
//  Created by Michael Miller on 9/17/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

extension Double {
    
    func toFiat() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // TODO: Support specific locales
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = self < 1.0 ? 4 : 2
        return formatter.string(from: self as NSNumber) ?? "error"
    }
    
    func toBitcoins() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = self == 1.0 ? 0 : 8
        var str = formatter.string(from: self as NSNumber) ?? "error"
        
        // Remove trailing "0"s
        while (str.last == "0" && str.count > 0) {
            str = String(str.dropLast())
        }
        
        // This should not happen
        // But, if it does, "0" will be used
        if (str.last == ".") {
            str = "0"
        }
        
        return str
    }
    
}
