//
//  AnimatedView.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class AnimatedView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatedDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateUp()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateUp()
    }
    
    private func animatedDown() {
        UIView.animate(withDuration: Theme.defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.alpha = 0.6
        })
    }

    private func animateUp() {
        UIView.animate(withDuration: Theme.defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        })
    }

}
