//
//  UIView.swift
//  wallet
//
//  Created by Michael Miller on 8/23/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewAndFill(_ view: UIView, top: CGFloat = 0.0, bottom: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
    }
    
    func addGradient(startColor: UIColor, endColor: UIColor) {
        layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        layer.insertSublayer(gradient, at: 0)
    }
    
}
