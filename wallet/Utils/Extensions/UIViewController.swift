//
//  UIViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UIViewController {
    func themeSetup() {
        let backgroundColor: UIColor = .black //TODO move all colors to theme file
        let textColor: UIColor = .white
        
        view.backgroundColor = backgroundColor
        
        //Nav setup
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = textColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor
//            NSAttributedString.Key.font:
        ]
    }
    
    func hideKeyboardWhenSwipedDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
