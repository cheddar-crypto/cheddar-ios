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
    
    func animateIn(duration: TimeInterval = 0.25, fromScale: CGFloat = 0.9, delay: TimeInterval = 0.0, onComplete: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        }, completion: { complete in
            onComplete?()
        })
    }
    
    func animateOut(duration: TimeInterval = 0.25, toScale: CGFloat = 0.9, delay: TimeInterval = 0.0, onComplete: (() -> Void)? = nil) {
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: toScale, y: toScale)
            self.alpha = 0
        }, completion: { complete in
            self.isHidden = true
            onComplete?()
        })
    }
    
}
