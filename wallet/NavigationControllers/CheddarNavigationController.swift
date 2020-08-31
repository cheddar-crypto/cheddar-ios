//
//  CheddarNavigationController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarNavigationController<VM: ViewModel>: UINavigationController, UIGestureRecognizerDelegate {
    
    internal var viewModel: VM! {
        didSet {
            viewModelDidLoad()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VM()
        setTheme()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func viewModelDidLoad() {
        // Empty
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}
