//
//  RequestAmountViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestAmountViewController: CheddarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Request Amount"

        let button = UIButton()
        button.setTitleColor(Theme.inverseBackgroundColor, for: .normal)
        button.setTitle("Show note", for: .normal)
        button.frame = CGRect(x: 0, y: 60, width: 200, height: 50)
        view.addSubview(button)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = Theme.inverseBackgroundColor.cgColor
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        
    }
    
    @objc private func push() {
        (navigationController as? CheddarNavigationController)?.pushRequestNote()
    }

}
