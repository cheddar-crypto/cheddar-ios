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
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.numberOfLines = 0
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.text20)
        return label
    }()
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
        layer.cornerRadius = Dimens.view44 / 2
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        action()
    }
    
    private func addLabel() {
        let padding = Dimens.margin12
        addSubviewAndFill(label, top: padding + 2.0, bottom: -padding, leading: padding, trailing: -padding)
    }

}
