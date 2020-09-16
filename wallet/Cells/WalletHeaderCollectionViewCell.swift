//
//  WalletHeaderCollectionViewCell.swift
//  wallet
//
//  Created by Michael Miller on 9/15/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class WalletHeaderCollectionViewCell: UICollectionViewCell {
    
    public static let id = "WalletHeaderCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let currencyView: CurrencyInputView = {
        let view = CurrencyInputView(prefixChar: "$", action: {
            print("asdasd")
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.inverseBackgroundColor
        label.textAlignment = .center
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressButton: CheddarButton = {
        let button = CheddarButton(style: .bordered, action: {
            if let click = self.addressButtonClick {
                click()
            }
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addressButtonClick: (() -> Void)? = nil
    
    private var containerViewWidthAnchor: NSLayoutConstraint!
    private var containerViewHeightContraint: NSLayoutConstraint!
    var maxWidth: CGFloat? {
        didSet {
            guard let maxWidth = maxWidth else { return }
            containerViewWidthAnchor.constant = maxWidth
            containerViewWidthAnchor.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addContainer()
        addCurrencyView()
        addAmountView()
        addAddressButton()
    }
    
    private func addContainer() {
        contentView.addSubviewAndFill(containerView)
        containerViewHeightContraint = contentView.heightAnchor.constraint(equalToConstant: 200)
        containerViewHeightContraint.isActive = true
        containerViewWidthAnchor = containerView.widthAnchor.constraint(equalToConstant: 0)
    }
    
    private func addCurrencyView() {
        containerView.addSubview(currencyView)
        currencyView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        currencyView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        currencyView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        currencyView.setStyle(style: .header, animated: false)
    }
    
    private func addAmountView() {
        containerView.addSubview(amountLabel)
        amountLabel.topAnchor.constraint(equalTo: currencyView.bottomAnchor).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: currencyView.leadingAnchor).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: currencyView.trailingAnchor).isActive = true
    }
    
    private func addAddressButton() {
        containerView.addSubview(addressButton)
        addressButton.title = .seeBitcoinAddress
        addressButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat(Dimens.largeMargin)).isActive = true
        addressButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        addressButton.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Dimens.minButtonWidth)).isActive = true
        addressButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
}
