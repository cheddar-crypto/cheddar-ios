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
        present(RequestPaymentNavigationController(), animated: true, completion: nil)
    }
    
}

extension CheddarNavigationController {
    
    func pushRequestNote() {
        pushViewController(RequestNoteViewController(), animated: true)
    }
    
    func pushInvoiceQR() {
        pushViewController(RequestInvoiceQRViewController(), animated: true)
    }
    
}
