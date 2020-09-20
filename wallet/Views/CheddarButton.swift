//
//  CheddarButton.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarButton: AnimatedView {
    
    enum Style {
        case primary
        case bordered
    }
    
    private var style: Style = .primary
    @objc private var action: () -> Void
    private var didSetCorners = false
    private let label = UILabel()
    var title: String? {
        get {
            return label.text
        }
        set(newTitle) {
            label.text = newTitle?.uppercased()
        }
    }

    init(style: Style = .primary, action: @escaping () -> Void) {
        self.style = style
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
        setStyle()
    }
    
    private func setStyle() {
        switch style {
        case .primary:
            label.textColor = .gray900
            backgroundColor = Theme.primaryColor
        case .bordered:
            label.textColor = Theme.inverseBackgroundColor
            backgroundColor = Theme.backgroundColor
            layer.borderWidth = CGFloat(Dimens.shadow)
            layer.borderColor = Theme.shadowColor.cgColor
        }
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        self.action()
    }
    
    private func addLabel() {
        label.textAlignment = .center
        label.font = Fonts.sofiaPro(weight: .bold, Dimens.titleText)
        self.addSubviewAndFill(label, top: 2.0, leading: CGFloat(Dimens.midMargin), trailing: -CGFloat(Dimens.midMargin))
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if (!didSetCorners) {
            didSetCorners = true
            layer.cornerRadius = frame.height / 2
        }
    }
    
}
