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
    func registerPriceChangeListener(onSuccess: @escaping (Double) -> Void, onFailure: @escaping (Error) -> Void) {
        
        // This gets called every 10 seconds
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            let price = Double.random(in: 9000.0...12000.0)
            onSuccess(price)
        }
        
    }
    
}
