//
//  CurrencyInputView.swift
//  wallet
//
//  Created by Michael Miller on 9/1/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CurrencyInputView: AnimatedView {

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

    init(action: @escaping () -> Void) {
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

}
