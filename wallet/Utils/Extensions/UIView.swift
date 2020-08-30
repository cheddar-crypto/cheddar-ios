//
//  UIView.swift
//  wallet
//
//  Created by Michael Miller on 8/23/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewAndFill(_ view: UIView, top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
    }
    
}
