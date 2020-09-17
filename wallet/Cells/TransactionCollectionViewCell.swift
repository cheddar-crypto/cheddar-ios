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
        return label
    }()
    
    private let cryptoAmountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        return label
    }()
    
    private let fiatAmountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.titleTallText)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        return label
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shadowColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentViewWidthConstraint: NSLayoutConstraint!
    private var textViewHeightContraint: NSLayoutConstraint!
    var maxWidth: CGFloat? {
        didSet {
            guard let maxWidth = maxWidth else { return }
            contentViewWidthConstraint.constant = maxWidth
            contentViewWidthConstraint.isActive = true
            let sizeToFitIn = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
            let newSize = messageTextView.sizeThatFits(sizeToFitIn)
            textViewHeightContraint.constant = newSize.height
        }
    }
    
    var transaction: Transaction? = nil {
        didSet {
            senderLabel.text = "\(transaction!.isSent)"
            cryptoAmountLabel.text = "\(transaction!.amount)"
            messageTextView.text = transaction?.message
            let image = transaction!.isSent ? UIImage.send : UIImage.receive
            imageView.image = image.tint(Theme.inverseBackgroundColor)
            fiatAmountLabel.text = "-$12.00"
            dateLabel.text = "\(transaction!.date)"
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
        
        // Setup content view
        contentView.backgroundColor = .clear
        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        
        // Add other views
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
        dateLabel.topAnchor.constraint(greaterThanOrEqualTo: fiatAmountLabel.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat(Dimens.mmdnMargin)).isActive = true
    }
    
    private func addMessage() {
        contentView.addSubview(messageTextView)
        messageTextView.leadingAnchor.constraint(equalTo: senderLabel.leadingAnchor).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageTextView.topAnchor.constraint(equalTo: cryptoAmountLabel.bottomAnchor, constant: CGFloat(Dimens.shortMargin)).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(Dimens.mmdnMargin)).isActive = true
        textViewHeightContraint = messageTextView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func addBottomBorder() {
        contentView.addSubview(bottomBorder)
        bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.shadow)).isActive = true
    }
    
}
