//
//  UIViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setTheme() {
        
        view.backgroundColor = Theme.backgroundColor
        
        //Nav setup
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = Theme.inverseBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Theme.inverseBackgroundColor,
            NSAttributedString.Key.font: Fonts.sofiaPro(weight: .medium, Dimens.title)
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
