//
//  SwipeToSendCoordinator.swift
//  wallet
//
//  Created by Michael Miller on 9/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class SwipeToSendCoordinator {
    
    struct Offset {
        let min: CGFloat
        let max: CGFloat
    }
    
    // MARK: Constants
    private static let animationDuration = 0.3
    private static let sendableVelocityThreshold: CGFloat = 2200
    private static let sendableDistanceThreshold: CGFloat = 0.4
    
    private let gestureView: UIView
    private var views: [UIView: Offset] = [:]
    private let onDrag: (CGFloat) -> Void
    private let onSend: () -> Void
    private lazy var screenHeight = window?.frame.height ?? UIScreen.main.bounds.height
    private lazy var window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    private lazy var minReleasePointY = screenHeight * SwipeToSendCoordinator.sendableDistanceThreshold
    
    init(views: [UIView], gestureView: UIView, onOffsetChange: @escaping (CGFloat) -> Void, onSend: @escaping () -> Void) {
        
        // Set listeners
        self.onDrag = onOffsetChange
        self.onSend = onSend
        
        // Init refs
        self.gestureView = gestureView
        let maxTranslationDistance = abs(screenHeight - gestureView.frame.maxY)
        views.forEach { view in
            let originY = view.frame.origin.y
            let offset = Offset(min: originY, max: originY - maxTranslationDistance)
            self.views[view] = offset
        }
        
        // Set the gesture view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        gestureView.addGestureRecognizer(panGesture)
        gestureView.addGestureRecognizer(tapGesture)
        gestureView.isUserInteractionEnabled = true
        
    }
    
    @objc private func tapView(_ sender: UIPanGestureRecognizer) {
        peek()
    }
    
    @objc private func panView(_ sender: UIPanGestureRecognizer) {
        switch (sender.state) {
        case .began, .changed:
            
            let translation = sender.translation(in: window)
            
            // Limit the views from going past their maxs
            // and below their mins
            for (view, offset) in views {
                let limitTop = max(view.frame.origin.y + translation.y, offset.max)
                view.frame.origin.y = min(limitTop, offset.min)
            }
            
            updateDragPosition(duration: 0)
            
            sender.setTranslation(CGPoint.zero, in: window)
            
        default:
            
            let velocity = sender.velocity(in: window)
            
            if (abs(velocity.y) >= SwipeToSendCoordinator.sendableVelocityThreshold) { // Exit due to swipe
                exit(velocity: 1)
            } else if (self.gestureView.frame.origin.y <= minReleasePointY) { // Exit due to "let go"
                exit(velocity: 0.75)
            } else { // Reset
                reset()
            }

        }
    }
    
    // Animates the view out
    private func exit(velocity: CGFloat) {
        UIView.animate(withDuration: SwipeToSendCoordinator.animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: {
            
            self.updateDragPosition(duration: SwipeToSendCoordinator.animationDuration)
            
            self.window?.layoutIfNeeded()
            
            // Perform the layout change
            for (view, offset) in self.views {
                view.frame.origin.y = offset.max
            }
            
            self.onSend()
            
        })
    }
    
    // Resets the views back to their original state
    func reset(animated: Bool = true) {
        
        let duration = animated ? SwipeToSendCoordinator.animationDuration : 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            self.updateDragPosition(duration: duration)
            
            self.window?.layoutIfNeeded()
            
            // Perform the layout change
            for (view, offset) in self.views {
                view.frame.origin.y = offset.min
            }
            
        })
        
    }
    
    // Brings the view up to imply the gesture
    private func peek() {
        let peekDistance: CGFloat = 40
        UIView.animate(
            withDuration: SwipeToSendCoordinator.animationDuration,
            animations: {
                self.window?.layoutIfNeeded()
                for (view, _) in self.views {
                    view.frame.origin.y -= peekDistance
                }
                self.updateDragPosition(duration: SwipeToSendCoordinator.animationDuration)
            },
            completion: { complete in
                self.reset(animated: complete)
            })
        
    }
    
    // Calls the listen for the current position
    // Will work if the change is only a reseting animation
    private func updateDragPosition(duration: TimeInterval) {
        
        guard let offset = views[gestureView] else { return }
        
        if (duration > 0) {
            let currentPosition = gestureView.frame.origin.y
            ValueAnimator(from: Double(currentPosition), to: Double(offset.min), duration: duration, valueUpdater: { value in
                let position = 1 - (CGFloat(value) / offset.min)
                self.onDrag(position)
            }).start()
        } else {
            let position = 1 - (gestureView.frame.origin.y / offset.min)
            self.onDrag(position)
        }
    
    }
    
}
