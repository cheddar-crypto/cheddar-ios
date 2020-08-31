//
//  Navigation.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

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
    
    func pushRequestNote(sharedViewModel: RequestViewModel) {
        pushViewController(RequestNoteViewController(sharedViewModel: sharedViewModel), animated: true)
    }
    
    func pushInvoiceQR(sharedViewModel: RequestViewModel) {
        pushViewController(RequestInvoiceQRViewController(sharedViewModel: sharedViewModel), animated: true)
    }
    
    func pushSendPayment() {
        pushViewController(SendPaymentViewController(), animated: true)
    }
    
}
