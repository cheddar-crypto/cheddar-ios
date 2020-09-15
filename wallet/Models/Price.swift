//
//  Price.swift
//  wallet
//
//  Created by Michael Miller on 9/13/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

struct Price: Codable {
    let usd: Double
}

extension Price {
    
    func forLocale() -> Double {
        return usd
    }
    
}
