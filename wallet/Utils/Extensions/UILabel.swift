//
//  UILabel.swift
//  wallet
//
//  Created by Michael Miller on 9/13/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setFont(animationDuration: TimeInterval, weight: FontStyle, newSize: CGFloat) {
        if (animationDuration > 0) {
            ValueAnimator(
                from: font.pointSize,
                to: newSize,
                duration: animationDuration,
                valueUpdater: { [weak self] value in
                    self?.font = Fonts.sofiaPro(weight: weight, value)
                }).start()
        } else {
            font = Fonts.sofiaPro(weight: weight, newSize)
        }
    }
    
}
