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
        
        private let label: UILabel
        private let onValueChange: (Double) -> Void
        
        var value: Double {
            get {
                let str = self.label.text ?? "0"
                return Double(str) ?? 0.0
            }
            set(newValue) {
                let text = String(newValue)
                self.label.text = format(text)
                onValueChange(value)
            }
        }
        
        init(label: UILabel, onValueChange: @escaping (Double) -> Void) {
            self.label = label
            self.label.text = "0"
            self.onValueChange = onValueChange
        }
        
        func addCharacter(char: String) {
            let str = (self.label.text ?? "")
            
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
            self.label.text = format(text)
            onValueChange(value)
        }
        
        func removeCharacter() {
            var text = String(self.label.text?.dropLast() ?? "")
            
            if (text.isEmpty) {
                text = "0"
            }
            
            self.label.text = format(text)
            onValueChange(value)
        }
        
        private func format(_ text: String) -> String {
            
            // TODO
//            let formatter = NumberFormatter()
//            formatter.locale = Locale.current
//            formatter.numberStyle = .decimal
            
            return text
            
        }
        
    }

}
