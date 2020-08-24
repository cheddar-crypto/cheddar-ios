//
//  PaymentNavigationController.swift
//  wallet
//
//  Created by Michael Miller on 8/22/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class PaymentNavigationController: CheddarNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([ScanInvoiceViewController()], animated: false)
    }

}
