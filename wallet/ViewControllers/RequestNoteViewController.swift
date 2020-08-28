//
//  RequestNoteViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestNoteViewController: CheddarViewController<ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Note"
        
        setLeftNavigationButton(.back)

        let button = UIButton()
        button.setTitleColor(Theme.inverseBackgroundColor, for: .normal)
        button.setTitle("Show QR Invoice Screen", for: .normal)
        button.frame = CGRect(x: 0, y: 60, width: 200, height: 50)
        view.addSubview(button)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = Theme.inverseBackgroundColor.cgColor
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        
    }
    
    @objc private func push() {
        (navigationController as? CheddarNavigationController)?.pushInvoiceQR()
    }

}
