//
//  RequestViewModel.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class RequestViewModel: ViewModel {
    
    let amount = Observable<Double>()
    let note = Observable<String?>()
    let invoice = Observable<String>()
    let price = Observable<Price>()
    
    func load() {
        self.price.value = GlobalSettings.price
    }
    
    func getAmountTitle() -> String {
        if let price = price.value {
            let count = amount.value ?? 0.0
            let bitcoins = String.bitcoinCount(count).lowercased()
            let cost = (count * price.forLocale()).toFiat()
            return "\(bitcoins) (\(cost))"
        } else {
            return ""
        }
    }
    
    // TODO: Add the proper repo or values in here to handle creating the lnd invoice
    func createInvoice() {
        
        let example = "lightning:lnbcrt5u1pdam80cpp5hrx4jp3hwe0vrl3jyft95fnfvgsvc327xw5j63mfchc6nazl87csdphf35kw6r5wahhy6eqx43xgepev3jkxctyxumrjdrxxqmn2ctrve3njvscqzys9htkyg7r5kesumuhkntta8syzc2uclqj2lrq5spwppa2r4d2dm49pkhpjemjp3rrm0se4cmakcqgrakpk9hlnv2mgj3dus3yujfzhqsqa7satk"
        
        invoice.value = example
        
    }
    
}
