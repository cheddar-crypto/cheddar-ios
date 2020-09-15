//
//  CheddarNumberPad.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarNumberPad: UIView {
    
    private var stackViews: [UIStackView] = []
    @objc private var onItemClicked: (String) -> Void
    @objc private var onBackspaceClicked: () -> Void

    init(onItemClicked: @escaping (String) -> Void, onBackspaceClicked: @escaping () -> Void) {
        self.onItemClicked = onItemClicked
        self.onBackspaceClicked = onBackspaceClicked
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = Theme.shadowColor
        createButtons()
    }
    
    private func createButtons() {
        
        // Clear the views
        subviews.forEach({ $0.removeFromSuperview() })
        stackViews.removeAll()
        
        // Create the vertical stack
        let vStack = UIStackView()
        vStack.spacing = CGFloat(Dimens.shadow)
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        
        // Split the numbers into 3 chunks
        let tileSets = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            [".", "0", nil]
        ]
        
        // Add the horizontal stack to the vertical stack
        tileSets.forEach({ tiles in
            let hStack = makeHStack(items: tiles)
            vStack.addArrangedSubview(hStack)
        })
        
        // Add the stack to the view
        addSubviewAndFill(vStack, top: CGFloat(Dimens.shadow), bottom: -CGFloat(Dimens.shadow))
        
    }
    
    private func makeButton(title: String?, action: @escaping () -> Void) -> CheddarNumberPadButton {
        let button = CheddarNumberPadButton(action: action)
        
        if let title = title {
            button.title = title
        } else {
            button.image = .delete
        }
        
        button.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.tall)).isActive = true
        return button
    }
    
    private func makeHStack(items: [String?]) -> UIStackView {
        let bottomButtons = items.map({ item in
            return makeButton(title: item, action: { [weak self] in
                if let item = item {
                    self?.onItemClicked(item)
                } else {
                    self?.onBackspaceClicked()
                }
            })
        })
        let hStack = UIStackView(arrangedSubviews: bottomButtons)
        hStack.spacing = CGFloat(Dimens.shadow)
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        return hStack
    }
    
    // MARK: Coordinator
    // Coordinates the number pad and what is shown in another field
    class Coordinator {
        
        private let cryptoView: CurrencyInputView
        private let fiatView: CurrencyInputView
        private let onValueChange: (Double) -> Void
        
        public var currentPrice: Double = 0.0
        public var selectedInputView: CurrencyInputView
        
        var value: Double {
            get {
                let str = cryptoView.title ?? "0"
                return Double(str) ?? 0.0
            }
            set(newValue) {
                let text = String(newValue)
                cryptoView.title = format(text)
                onValueChange(value)
            }
        }
        
        init(fiatView: CurrencyInputView, cryptoView: CurrencyInputView, onValueChange: @escaping (Double) -> Void) {
            self.fiatView = fiatView
            self.cryptoView = cryptoView
            self.selectedInputView = fiatView
            self.onValueChange = onValueChange
        }
        
        func addCharacter(char: String) {
            let str = (selectedInputView.title ?? "")
            
            // Prevent "." duplicates
            if (char == "." && str.contains(".")) {
                return
            }
            
            // Set the proper value
            var text = str
            if (text.starts(with: "0") && text.count == 1) {
                if (char == ".") {
                    text = "0" + char
                } else {
                    text = char
                }
            } else {
                text += char
            }
            
            // Handle zero start
            if (text == "0") {
                text += "."
            }
            
            // Update the value
            selectedInputView.title = format(text)
            refresh()
            onValueChange(value)
        }
        
        func removeCharacter() {
            var text = String(selectedInputView.title?.dropLast() ?? "")
            
            if (text.isEmpty) {
                text = "0"
            }
            
            selectedInputView.title = format(text)
            refresh()
            onValueChange(value)
        }
        
        private func format(_ text: String) -> String {
            
            // TODO
//            let formatter = NumberFormatter()
//            formatter.locale = Locale.current
//            formatter.numberStyle = .decimal
            
            return text
            
        }
        
        private func refresh() {
            if (selectedInputView == fiatView) {
                let str = fiatView.title ?? "0"
                let fiatAmount = Double(str) ?? 0.0
                let cryptoAmount = fiatAmount / currentPrice
                cryptoView.title = String(cryptoAmount)
            } else {
                let str = cryptoView.title ?? "0"
                let cryptoAmount = Double(str) ?? 0.0
                let fiatAmount = cryptoAmount * currentPrice
                fiatView.title = String(fiatAmount)
            }
        }
        
    }

}
