//
//  ValueAnimator.swift
//  wallet
//
//  Created by Michael Miller on 9/13/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

// swiftlint:disable:next private_over_fileprivate
fileprivate var defaultFunction: (TimeInterval, TimeInterval) -> (CGFloat) = { time, duration in
    return (CGFloat)(time / duration)
}

class ValueAnimator {

  let from: CGFloat
  let to: CGFloat
  var duration: TimeInterval = 0
  var startTime: Date!
  var displayLink: CADisplayLink?
  var animationCurveFunction: (TimeInterval, TimeInterval) -> (CGFloat)
  var valueUpdater: (CGFloat) -> Void

  init(from: CGFloat = 0, to: CGFloat = 1, duration: TimeInterval, animationCurveFunction: @escaping (TimeInterval, TimeInterval) -> (CGFloat) = defaultFunction, valueUpdater: @escaping (CGFloat) -> Void) {
    self.from = from
    self.to = to
    self.duration = duration
    self.animationCurveFunction = animationCurveFunction
    self.valueUpdater = valueUpdater
  }

  func start() {
    displayLink = CADisplayLink(target: self, selector: #selector(update))
    displayLink?.add(to: .current, forMode: .default)
  }

  @objc
  private func update() {

    if startTime == nil {
      startTime = Date()
      valueUpdater(from + (to - from) * animationCurveFunction(0, duration))
      return
    }

    var timeElapsed = Date().timeIntervalSince(startTime)
    var stop = false

    if timeElapsed > duration {
      timeElapsed = duration
      stop = true
    }

    valueUpdater(from + (to - from) * animationCurveFunction(timeElapsed, duration))

    if stop {
      cancel()
    }
  }

  func cancel() {
    self.displayLink?.remove(from: .current, forMode: .default)
    self.displayLink = nil
  }
}
