//
//  CheddarChip.swift
//  wallet
//
//  Created by Michael Miller on 9/1/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarChip: AnimatedView {

    @objc private var action: () -> Void
    private var didSetCorners = false
    private let label = UILabel()
    var title: String? {
        get {
            return label.text
        }
        set(newTitle) {
            label.text = newTitle
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
        backgroundColor = Theme.primaryColor
        clipsToBounds = true
        addLabel()
        addTapRecognizer()
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        self.action()
    }
    
    private func addLabel() {
        label.textColor = .gray900
        label.textAlignment = .center
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        self.addSubviewAndFill(label, top: 2.0, leading: 12.0, trailing: -12.0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if (!didSetCorners) {
            didSetCorners = true
            layer.cornerRadius = frame.height / 2
        }
    }

}
