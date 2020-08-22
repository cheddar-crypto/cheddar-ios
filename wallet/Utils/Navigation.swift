//
//  Navigation.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

// Not sure I like this yet...

extension CheddarViewController {
    
    func presentRequestPayment() {
        present(RequestNavigationController(), animated: true, completion: nil)
    }
    
    func presentPayment() {
        present(PaymentNavigationController(), animated: true, completion: nil)
    }
    
    func presentOnChainAddress() {
        present(OnChainAddressViewController(), animated: true, completion: nil)
    }
    
}

extension CheddarNavigationController {
    
    func pushRequestNote() {
        pushViewController(RequestNoteViewController(), animated: true)
    }
    
    func pushInvoiceQR() {
        pushViewController(RequestInvoiceQRViewController(), animated: true)
    }
    
    func pushSendPayment() {
        pushViewController(SendPaymentViewController(), animated: true)
    }
    
}
