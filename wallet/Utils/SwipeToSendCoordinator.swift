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
    private static let animationDuration = 0.2
    private static let sendableVelocityThreshold: CGFloat = -2200
    private static let sendableDistanceThreshold: CGFloat = 0.5
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
    
    private let gestureView: UIView
    private lazy var gestureViewOffset: Offset = {
        let min = gestureView.frame.origin.y
        let max = min - abs(screenHeight - gestureView.frame.maxY)
        return Offset(min: min, max: max)
    }()
    
    private let onDrag: (_ travelDistance: CGFloat, _ position: CGFloat) -> Void
    private let onSend: () -> Void
    private lazy var screenHeight = window?.frame.height ?? UIScreen.main.bounds.height
    private lazy var window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    private lazy var minReleasePointY = screenHeight * SwipeToSendCoordinator.sendableDistanceThreshold
    
    init(gestureView: UIView, onOffsetChange: @escaping (CGFloat, CGFloat) -> Void, onSend: @escaping () -> Void) {
        
        self.onDrag = onOffsetChange
        self.onSend = onSend
        self.gestureView = gestureView
        
        // Set the gesture view
        addGestures()
        gestureView.isUserInteractionEnabled = true
        
    }
    
    private func addGestures() {
        gestureView.addGestureRecognizer(panGesture)
        gestureView.addGestureRecognizer(tapGesture)
    }
    
    private func removeGestures() {
        gestureView.removeGestureRecognizer(panGesture)
        gestureView.removeGestureRecognizer(tapGesture)
    }
    
    @objc private func tapView(_ sender: UIPanGestureRecognizer) {
        peek()
    }
    
    @objc private func panView(_ sender: UIPanGestureRecognizer) {
        switch (sender.state) {
        case .began, .changed:
            
            let translation = sender.translation(in: window)
            
            // Limit the view from going past it's max and below it's mins
            let limitTop = max(gestureView.frame.origin.y + translation.y, gestureViewOffset.max)
            gestureView.frame.origin.y = min(limitTop, gestureViewOffset.min)
            
            // Call listener
            let position = 1 - (gestureView.frame.origin.y / gestureViewOffset.min)
            onDrag(gestureViewOffset.min, position)
            
            sender.setTranslation(CGPoint.zero, in: window)
            
        default:
            
            // Determine the speed of the animation
            let velocity = sender.velocity(in: window)
            let slice = min(minReleasePointY / abs(velocity.y), 0.2)
            let flingDuration = TimeInterval(max(slice, 0.05))
            
            // User flung up
            if (velocity.y <= SwipeToSendCoordinator.sendableVelocityThreshold) {
                exit(duration: flingDuration)
            }
            
            // User is pulling back down
            else if (velocity.y > 0) {
                reset(duration: SwipeToSendCoordinator.animationDuration)
            }
            
            // User let go above min release point
            else if (gestureView.frame.origin.y <= minReleasePointY) {
                exit(duration: flingDuration)
            }
                
            // Reset
            else {
                reset(duration: SwipeToSendCoordinator.animationDuration)
            }

        }
    }
    
    // Animates the view out
    private func exit(duration: TimeInterval) {
        
        ValueAnimator(from: gestureView.frame.origin.y, to: gestureViewOffset.max, duration: duration, valueUpdater: { [weak self] value in
            guard let self = self else { return }
            
            let v = CGFloat(value)
            let offset = v / self.gestureViewOffset.min
            if (!offset.isNaN) {
                
                // Update the position
                self.gestureView.frame.origin.y = v
                self.onDrag(self.gestureViewOffset.min, 1 - offset)
                
                // Tell if complete
                if (value == self.gestureViewOffset.max) {
                    self.onSend()
                    self.removeGestures()
                }
                
            }
            
        }).start()

    }
    
    // Resets the views back to their original state
    func reset(duration: TimeInterval) {
        
        ValueAnimator(from: gestureView.frame.origin.y, to: gestureViewOffset.min, duration: duration, valueUpdater: { [weak self] value in
            guard let self = self else { return }
            
            let offset = value / self.gestureViewOffset.min
            if (!offset.isNaN) {
                self.gestureView.frame.origin.y = value
                self.onDrag(self.gestureViewOffset.min, 1 - offset)
            }
            
            if (value == self.gestureViewOffset.min) {
                self.isPeeking = false
                self.addGestures()
            }
            
        }).start()
        
    }
    
    // Brings the view up to imply the gesture
    private var isPeeking = false
    private func peek() {
        
        // Disable peeking if already peeking
        if (isPeeking) {
            return
        }
        
        let peekAmount = gestureViewOffset.min - Dimens.margin16
        let duration = SwipeToSendCoordinator.animationDuration
        isPeeking = true
        
        ValueAnimator(from: gestureViewOffset.min, to: peekAmount, duration: duration, valueUpdater: { [weak self] value in
            guard let self = self else { return }
            
            // Animate
            let offset = value / self.gestureViewOffset.min
            if (!offset.isNaN) {
                self.gestureView.frame.origin.y = value
                self.onDrag(self.gestureViewOffset.min, 1 - offset)
            }
            
            // When ended, start reset
            if (value == peekAmount) {
                self.reset(duration: duration)
            }
            
        }).start()
        
    }
    
}
