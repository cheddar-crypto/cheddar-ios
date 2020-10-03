//
//  PaymentViewModel.swift
//  wallet
//
//  Created by Michael Miller on 9/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class PaymentViewModel: ViewModel {
    
    struct Payment {
        let someValue: Int
    }
    
    let invoice = Observable<String>()
    let bitcoinAddress = Observable<String>()
    let note = Observable<String?>()
    let isLoading = Observable<Bool>()
    let error = Observable<Error>()
    let paymentSent = Observable<Payment>()
    
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
    
    func sendPayment() {
        print("Sending! 🧀")
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.isLoading.value = false
            self.paymentSent.value = Payment(someValue: 123)
        }
    }
    
}
