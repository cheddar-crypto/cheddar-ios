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
    
    let messageLabel: UILabel = {
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
    
    var transaction: Transaction? = nil {
        didSet {
            senderLabel.text = "\(transaction!.isSent)"
            cryptoAmountLabel.text = "\(transaction!.amount)"
            messageLabel.text = transaction?.message
            let image = transaction!.isSent ? UIImage.send : UIImage.receive
            imageView.image = image.tint(Theme.inverseBackgroundColor)
            fiatAmountLabel.text = "-$12.00"
            dateLabel.text = "\(transaction!.date)"
            
            // Fix bug where nil message gets pushed up
            messageTopConstraint.constant = transaction?.message == nil ? 0 : CGFloat(Dimens.shortMargin)
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
        backgroundColor = .clear
        addImageView()
        addSenderLabel()
        addCryptoLabel()
        addFiatLabel()
        addDateLabel()
        addMessage()
        addBottomBorder()
    }
    
    private func addImageView() {
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(Dimens.mmdnMargin)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func addSenderLabel() {
        contentView.addSubview(senderLabel)
        senderLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        senderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        senderLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    }
    
    private func addCryptoLabel() {
        contentView.addSubview(cryptoAmountLabel)
        cryptoAmountLabel.leadingAnchor.constraint(equalTo: senderLabel.leadingAnchor).isActive = true
        cryptoAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cryptoAmountLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: CGFloat(Dimens.shortMargin)).isActive = true
    }
    
    private func addFiatLabel() {
        contentView.addSubview(fiatAmountLabel)
        fiatAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        fiatAmountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(Dimens.mmdnMargin)).isActive = true
    }
    
    private func addDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        dateLabel.topAnchor.constraint(greaterThanOrEqualTo: cryptoAmountLabel.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat(Dimens.mmdnMargin)).isActive = true
    }
    
    private func addMessage() {
        contentView.addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: senderLabel.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CGFloat(Dimens.button)).isActive = true
        messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: cryptoAmountLabel.bottomAnchor) // May get set when transaction is set
        messageTopConstraint.isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat(Dimens.mmdnMargin)).isActive = true
    }
    
    private func addBottomBorder() {
        contentView.addSubview(bottomBorder)
        bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.shadow)).isActive = true
    }
    
}
