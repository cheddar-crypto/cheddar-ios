//
//  RequestPaymentNavigationController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestNavigationController: CheddarNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([RequestAmountViewController()], animated: false)
    }

}
