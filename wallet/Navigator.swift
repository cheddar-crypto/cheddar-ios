//
//  Navigation.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class Navigator {
    
    public static func pushRequestAmount(_ viewController: UIViewController) {
        if let navController = viewController.navigationController {
            let vc = RequestAmountViewController()
            navController.pushViewController(vc, animated: true)
        }
    }
    
    public static func pushRequestNote(_ viewController: UIViewController, sharedViewModel: RequestViewModel) {
        if let navController = viewController.navigationController {
            let vc = RequestNoteViewController(sharedViewModel: sharedViewModel)
            navController.pushViewController(vc, animated: true)
        }
    }
    
    public static func pushPaymentQR(_ viewController: UIViewController, sharedViewModel: RequestViewModel) {
        if let navController = viewController.navigationController {
            let vc = RequestInvoiceQRViewController(sharedViewModel: sharedViewModel)
            navController.pushViewController(vc, animated: true)
        }
    }
    
    public static func pushPaymentScan(_ viewController: UIViewController) {
        if let navController = viewController.navigationController {
            let vc = ScanInvoiceViewController()
            navController.pushViewController(vc, animated: true)
        }
    }
    
    public static func pushPaymentSend(_ viewController: UIViewController) {
        if let navController = viewController.navigationController {
            let vc = SendPaymentViewController()
            navController.pushViewController(vc, animated: true)
        }
    }
    
    public static func showOnChainAddress(_ viewController: UIViewController) {
        viewController.present(OnChainAddressViewController(), animated: true, completion: nil)
    }
    
}
