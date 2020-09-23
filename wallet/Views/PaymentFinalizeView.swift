//
//  PaymentFinalizeView.swift
//  wallet
//
//  Created by Michael Miller on 9/22/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class PaymentFinalizeView: UIView {
    
    private var onDoneAction: (() -> Void)? = nil
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    private lazy var doneButton: CheddarButton = {
        let view = CheddarButton(style: .white, action: {
            self.onDoneAction?()
        })
        view.title = .done
        view.isHidden = true
        return view
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        doneButton.isHidden = true
    }
    
    func showContent(onDoneAction: @escaping () -> Void) {
        self.onDoneAction = onDoneAction
        loadingIndicator.isHidden = true
        doneButton.isHidden = false
    }
    
    private func setup() {
        backgroundColor = Theme.primaryColor
        addLoadingIndicator()
        addDoneButton()
    }
    
    private func addLoadingIndicator() {
        addSubviewAndFill(loadingIndicator)
    }
    
    private func addDoneButton() {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            addSubview(doneButton)
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(window.safeAreaInsets.bottom + CGFloat(Dimens.mediumMargin))).isActive = true
        }
    }

}
