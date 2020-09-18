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
    public static let cellHeight: CGFloat = 200
    
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
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shadowColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var price: Price? = nil
    private var wallet: Wallet? = nil
    
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
        addBottomBorder()
    }
    
    private func addContainer() {
        contentView.addSubviewAndFill(containerView)
    }
    
    private func addCurrencyView() {
        containerView.addSubview(currencyView)
        currencyView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(Dimens.largeMargin)).isActive = true
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
        addressButton.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: CGFloat(Dimens.largeMargin)).isActive = true
        addressButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        addressButton.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Dimens.minButtonWidth)).isActive = true
        addressButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    private func addBottomBorder() {
        contentView.addSubview(bottomBorder)
        bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.shadow)).isActive = true
    }
    
    public func setWallet(_ wallet: Wallet, price: Price) {
        
        // Add datasource
        self.wallet = wallet
        self.price = price
        
        // Set the total
        let newTotal = wallet.balance * price.forLocale()
        currencyView.title = newTotal.toFiat()
        amountLabel.text = String.bitcoinCount(wallet.balance).lowercased()
        
    }
    
    // Handles refreshing the price in real time
    public func updatePrice(_ price: Price) {
        if let wallet = self.wallet {
            
            // Get the previous price
            let prevPrice = self.price
            let fallbackPrice = GlobalSettings.price
            let usablePrice = prevPrice ?? fallbackPrice
            let prevTotal = wallet.balance * usablePrice.forLocale()
            
            // Update to the new price
            let newTotal = wallet.balance * price.forLocale()
            self.price = price
            
            // Animate the change
            ValueAnimator(
                from: prevTotal,
                to: newTotal,
                duration: Theme.defaultAnimationDuration,
                valueUpdater: { value in
                    self.currencyView.title = value.toFiat()
                }).start()
            
        }
    }
    
}
