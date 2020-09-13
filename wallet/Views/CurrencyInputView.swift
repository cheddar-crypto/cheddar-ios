//
//  CurrencyInputView.swift
//  wallet
//
//  Created by Michael Miller on 9/1/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CurrencyInputView: AnimatedView {
    
    public enum Style {
        case Expanded
        case Collapsed
    }
    
    public static let minHeight = CGFloat(56.0)
    public static let maxHeight = CGFloat(104.0)
    
    private var currentStyle = Style.Collapsed
    var prefixChar: String // TODO: Use image
    @objc private var action: () -> Void
    private let label = UILabel()
    var title: String? {
        get {
            return label.text
        }
        set(newTitle) {
            label.text = newTitle?.uppercased()
        }
    }

    init(prefixChar: String, action: @escaping () -> Void) {
        self.prefixChar = prefixChar
        self.action = action
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        clipsToBounds = true
        addLabel()
        addTapRecognizer()
        layer.borderWidth = CGFloat(Dimens.shadow)
        layer.borderColor = Theme.shadowColor.cgColor
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        self.action()
    }
    
    private func addLabel() {
        label.textColor = Theme.inverseBackgroundColor
        label.textAlignment = .center
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.titleText)
        self.addSubviewAndFill(label)
    }
    
    func setStyle(style: Style, animated: Bool) {
        
        // Set the style if needed
        if (style == currentStyle) {
            return
        }
        currentStyle = style
        
        // Handle the change
        switch (style) {
        case .Expanded:
            layer.borderColor = Theme.primaryColor.cgColor
            
            if (animated) {
                ValueAnimator(
                from: Double(Dimens.titleText),
                to: Double(Dimens.headerText),
                duration: animated ? Theme.defaultAnimationDuration : 0,
                valueUpdater: { value in
                    self.label.font = Fonts.sofiaPro(weight: .bold, Int(value))
                }).start()
            } else {
                label.font = Fonts.sofiaPro(weight: .bold, Dimens.headerText)
            }

        case .Collapsed:
            layer.borderColor = Theme.shadowColor.cgColor
            if (animated) {
                ValueAnimator(
                from: Double(Dimens.headerText),
                to: Double(Dimens.titleText),
                duration: animated ? Theme.defaultAnimationDuration : 0,
                valueUpdater: { value in
                    self.label.font = Fonts.sofiaPro(weight: .medium, Int(value))
                }).start()
            } else {
                label.font = Fonts.sofiaPro(weight: .medium, Dimens.titleText)
            }
        }
    }

}
