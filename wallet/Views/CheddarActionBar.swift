//
//  CheddarActionBar.swift
//  wallet
//
//  Created by Michael Miller on 9/6/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarActionBar: UIView {
    
    private var leftButton: CheddarButton?
    private var rightButton: CheddarButton?
    
    private lazy var buttonStackView = {
        return UIStackView()
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = Theme.backgroundColor
        
        // Add shadow
        layer.shadowColor = Theme.shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: -Dimens.view2)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false

    }
    
    func setLeftAction(title: String, action: @escaping () -> Void) {
        leftButton?.removeFromSuperview()
        leftButton = CheddarButton(style: .bordered, action: action)
        leftButton!.title = title
        addSubview(leftButton!)
        leftButton!.translatesAutoresizingMaskIntoConstraints = false
        leftButton!.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.margin16).isActive = true
        leftButton!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.margin16).isActive = true
        leftButton!.heightAnchor.constraint(equalToConstant: Dimens.view56).isActive = true
        leftButton!.widthAnchor.constraint(greaterThanOrEqualToConstant: Dimens.view140).isActive = true
    }
    
    func setRightAction(title: String, action: @escaping () -> Void) {
        rightButton?.removeFromSuperview()
        rightButton = CheddarButton(action: action)
        rightButton!.title = title
        addSubview(rightButton!)
        rightButton!.translatesAutoresizingMaskIntoConstraints = false
        rightButton!.topAnchor.constraint(equalTo: topAnchor, constant: Dimens.margin16).isActive = true
        rightButton!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimens.margin16).isActive = true
        rightButton!.heightAnchor.constraint(equalToConstant: Dimens.view56).isActive = true
        rightButton!.widthAnchor.constraint(greaterThanOrEqualToConstant: Dimens.view140).isActive = true
    }

}
