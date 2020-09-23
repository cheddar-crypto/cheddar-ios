//
//  PaymentViewModel.swift
//  wallet
//
//  Created by Michael Miller on 9/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class PaymentViewModel: ViewModel {
    
    let invoice = Observable<String>()
    let bitcoinAddress = Observable<String>()
    let note = Observable<String?>()
    
    func postDiscoveredValue(value: String) {
        if (value.isBitcoinAddress) {
            bitcoinAddress.value = value
        } else if (value.isLightningInvoice) {
            invoice.value = value
        } else {
            // TODO: Tell user that is not a valid code
        }
        
        // TODO: Parse this from the lnd invoice
        note.value = "Chancellor on Brink of Second Bailout for Banks"
        
    }
    
    func getAmountTitle() -> String {
        // TODO
        return "0.0001 bitcoins ($1.24)"
    }
    
    func getReceiver() -> String {
        return bitcoinAddress.value ?? invoice.value ?? "invalid"
    }
    
}
