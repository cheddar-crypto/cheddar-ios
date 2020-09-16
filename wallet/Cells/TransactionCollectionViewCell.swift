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
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var containerViewWidthAnchor:NSLayoutConstraint!
    private var textViewHeightContraint: NSLayoutConstraint!
    var maxWidth: CGFloat? {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            containerViewWidthAnchor.constant = maxWidth
            containerViewWidthAnchor.isActive = true
            
            let sizeToFitIn = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
            let newSize = textView.sizeThatFits(sizeToFitIn)
            textViewHeightContraint.constant = newSize.height
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        contentView.addSubview(containerView)
        containerView.addSubview(textView)
        
        textViewHeightContraint = textView.heightAnchor.constraint(equalToConstant: 0)
        containerViewWidthAnchor = containerView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
