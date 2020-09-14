//
//  PriceRepository.swift
//  wallet
//
//  Created by Michael Miller on 9/13/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class PriceRepository {
    
    // TODO: Model this to the firestore price doc
    func registerPriceChangeListener(onSuccess: @escaping (Price) -> Void, onFailure: @escaping (Error) -> Void) {
        
        // This gets called every 10 seconds
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            let value = Double.random(in: 9000.0...12000.0)
            let price = Price(usd: value)
            onSuccess(price)
        }
        
    }
    
}
