//
//  CheddarNumberPadButton.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarNumberPadButton: AnimatedView {
    
    @objc private var action: () -> Void
    
    private lazy var label = {
        return UILabel()
    }()
    
    private lazy var imageView = {
        return UIImageView()
    }()
    
    var title: String {
        get {
            return label.text ?? ""
        }
        set(newTitle) {
            addLabel(title: newTitle)
        }
    }
    
    var image: UIImage {
        get {
            return imageView.image ?? UIImage()
        }
        set(newImage) {
            addImageView(image: newImage)
        }
    }

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = Theme.backgroundColor
        addTapRecognizer()
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        self.action()
    }
    
    private func addLabel(title: String) {
        label.textColor = Theme.inverseBackgroundColor
        label.textAlignment = .center
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.idkText)
        label.text = title.uppercased()
        if (!subviews.contains(label)) {
            self.addSubviewAndFill(label, top: 2.0)
        }
    }
    
    private func addImageView(image: UIImage) {
        imageView.contentMode = .center
        imageView.tintColor = Theme.inverseBackgroundColor
        imageView.image = image.tint(Theme.inverseBackgroundColor)
        if (!subviews.contains(imageView)) {
            self.addSubviewAndFill(imageView)
        }
    }
    
}
