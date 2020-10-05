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
        view.color = .gray900
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
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
        view.font = Fonts.sofiaPro(weight: .bold, Dimens.text24)
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
        self.doneButton.isHidden = true
        self.imageView.isHidden = true
        self.sentLabel.isHidden = true
        self.loadingIndicator.animateIn()
        self.loadingIndicator.startAnimating()
    }
    
    func showContent(onDoneAction: @escaping () -> Void) {
        
        self.onDoneAction = onDoneAction
        self.loadingIndicator.animateOut { [weak self] in
            self?.imageView.animateIn(fromScale: 0) { [weak self] in
                self?.sentLabel.animateIn(delay: 0.1) { [weak self] in
                    self?.doneButton.animateIn(delay: 0.1)
                }
            }
        }
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
            doneButton.heightAnchor.constraint(equalToConstant: Dimens.view56).isActive = true
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.margin16).isActive = true
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimens.margin16).isActive = true
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(window.safeAreaInsets.bottom + Dimens.margin16)).isActive = true
        }
    }
    
    private func addImageView() {
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -Dimens.view88).isActive = true
    }
    
    private func addSentLabel() {
        addSubview(sentLabel)
        sentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Dimens.margin32).isActive = true
        sentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimens.margin16).isActive = true
        sentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimens.margin16).isActive = true
    }

}
