//
//  RootNavigationController.swift
//  wallet
//
//  Created by Michael Miller on 9/15/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RootNavigationController: CheddarNavigationController<ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([HomeViewController()], animated: false)
    }

}
