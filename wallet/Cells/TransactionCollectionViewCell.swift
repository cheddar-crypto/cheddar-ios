//
//  TransactionCollectionViewCell.swift
//  wallet
//
//  Created by Michael Miller on 9/15/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {
    
    public static let id = "TransactionCollectionViewCell"
    
    private let containerView: AnimatedView = {
        let view = AnimatedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        view.tintColor = Theme.inverseBackgroundColor
        return view
    }()
    
    private let senderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.titleText)
        label.textColor = Theme.inverseBackgroundColor
        return label
    }()
    
    private let cryptoAmountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        label.textColor = Theme.inverseBackgroundColor
        return label
    }()
    
    private let fiatAmountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.titleTallText)
        label.textColor = Theme.inverseBackgroundColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        label.textColor = Theme.shadowColor
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        label.textColor = Theme.inverseBackgroundColor
        return label
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shadowColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var messageTopConstraint: NSLayoutConstraint!
    private var price: Price? = nil
    private var transaction: Transaction? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        addContainerView()
        addImageView()
        addSenderLabel()
        addCryptoLabel()
        addFiatLabel()
        addDateLabel()
        addMessage()
        addBottomBorder()
    }
    
    private func addContainerView() {
        contentView.addSubviewAndFill(containerView)
    }
    
    private func addImageView() {
        containerView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Dimens.mediumMargin).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Dimens.mmdnMargin).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func addSenderLabel() {
        containerView.addSubview(senderLabel)
        senderLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Dimens.mediumMargin).isActive = true
        senderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        senderLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    }
    
    private func addCryptoLabel() {
        containerView.addSubview(cryptoAmountLabel)
        cryptoAmountLabel.leadingAnchor.constraint(equalTo: senderLabel.leadingAnchor).isActive = true
        cryptoAmountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        cryptoAmountLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: Dimens.shortMargin).isActive = true
    }
    
    private func addFiatLabel() {
        containerView.addSubview(fiatAmountLabel)
        fiatAmountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Dimens.mediumMargin).isActive = true
        fiatAmountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Dimens.mmdnMargin).isActive = true
    }
    
    private func addDateLabel() {
        containerView.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Dimens.mediumMargin).isActive = true
        dateLabel.topAnchor.constraint(greaterThanOrEqualTo: cryptoAmountLabel.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Dimens.mmdnMargin).isActive = true
    }
    
    private func addMessage() {
        containerView.addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: senderLabel.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Dimens.button).isActive = true
        messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: cryptoAmountLabel.bottomAnchor) // May get set when transaction is set
        messageTopConstraint.isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Dimens.mmdnMargin).isActive = true
    }
    
    private func addBottomBorder() {
        contentView.addSubview(bottomBorder)
        bottomBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: Dimens.shadow).isActive = true
    }
    
    public func setTransaction(_ transaction: Transaction, price: Price) {
        
        // Add datasource
        self.transaction = transaction
        self.price = price
        
        // Update UI
        senderLabel.text = (transaction.isSent ? String.youSent : String.youReceived).lowercased()
        cryptoAmountLabel.text = String.bitcoinCount(transaction.amount).lowercased()
        messageLabel.text = transaction.message
        let image = transaction.isSent ? UIImage.send : UIImage.receive
        imageView.image = image.tint(Theme.inverseBackgroundColor)
        dateLabel.text = transaction.date.toTimeAgo()
        
        // Update the total
        let newTotal = transaction.amount * price.forLocale()
        fiatAmountLabel.text = addPrefix(isSent: transaction.isSent, value: newTotal)
        
        // Fix bug where nil message gets pushed up
        messageTopConstraint.constant = transaction.message == nil ? 0 : Dimens.shortMargin
        
    }
    
    // Handles refreshing the price in real time
    public func updatePrice(_ price: Price) {
        if let tx = transaction {
            
            // Get the previous price
            let prevPrice = self.price
            let fallbackPrice = GlobalSettings.price
            let usablePrice = prevPrice ?? fallbackPrice
            let prevTotal = tx.amount * usablePrice.forLocale()
            
            // Update to the new price
            let newTotal = tx.amount * price.forLocale()
            self.price = price
            
            // Animate the change
            ValueAnimator(
                from: CGFloat(prevTotal),
                to: CGFloat(newTotal),
                duration: Theme.defaultAnimationDuration,
                valueUpdater: { [weak self] value in
                    guard let self = self else { return }
                    self.fiatAmountLabel.text = self.addPrefix(isSent: tx.isSent, value: Double(value))
                }).start()
            
            // Update the date as a bonus
            dateLabel.text = tx.date.toTimeAgo()
            
        }
        
    }
    
    private func addPrefix(isSent: Bool, value: Double) -> String {
        return isSent ? "- \(value.toFiat())" : "+ \(value.toFiat())"
    }
    
}
