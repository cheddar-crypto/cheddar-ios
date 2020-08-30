//
//  RequestAmountViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestAmountViewController: CheddarViewController<ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

//        let button = UIButton()
//        button.setTitleColor(Theme.inverseBackgroundColor, for: .normal)
//        button.setTitle("Show note", for: .normal)
//        button.frame = CGRect(x: 0, y: 60, width: 200, height: 50)
//        view.addSubview(button)
//        button.layer.cornerRadius = 15
//        button.layer.borderWidth = 1
//        button.layer.borderColor = Theme.inverseBackgroundColor.cgColor
//        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        
    }
    
    private func setup() {
        
        // Navbar
        title = .request
        setLeftNavigationButton(.back, action: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        // Input areas
        let test = UIView()
        test.translatesAutoresizingMaskIntoConstraints = false
        test.backgroundColor = .red
        view.addSubview(test)
        test.heightAnchor.constraint(equalToConstant: 200).isActive = true
        test.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        test.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        test.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
    }
    
    @objc private func push() {
        (navigationController as? CheddarNavigationController)?.pushRequestNote()
    }

}
