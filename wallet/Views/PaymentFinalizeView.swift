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
        view.tintColor = .gray900
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var doneButton: CheddarButton = {
        let view = CheddarButton(style: .white, action: {
            self.onDoneAction?()
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = .done
        view.isHidden = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = .completedCheck
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let sentLabel: UILabel = {
        let view = UILabel()
        view.text = .paymentSent
        view.textColor = .gray900
        view.textAlignment = .center
        view.font = Fonts.sofiaPro(weight: .bold, Dimens.titleTallText)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.isHidden = true
        sentLabel.isHidden = true
    }
    
    func showContent(onDoneAction: @escaping () -> Void) {
        self.onDoneAction = onDoneAction
        loadingIndicator.isHidden = true
        doneButton.isHidden = false
        imageView.isHidden = false
        sentLabel.isHidden = false
    }
    
    private func setup() {
        backgroundColor = Theme.primaryColor
        addLoadingIndicator()
        addDoneButton()
        addImageView()
        addSentLabel()
    }
    
    private func addLoadingIndicator() {
        addSubviewAndFill(loadingIndicator)
    }
    
    private func addDoneButton() {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            addSubview(doneButton)
            doneButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(window.safeAreaInsets.bottom + CGFloat(Dimens.mediumMargin))).isActive = true
        }
    }
    
    private func addImageView() {
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -CGFloat(Dimens.bar)).isActive = true
    }
    
    private func addSentLabel() {
        addSubview(sentLabel)
        sentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: CGFloat(Dimens.largeMargin)).isActive = true
        sentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        sentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
    }

}
