//
//  Theme.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

struct Theme {
    
    public static let primaryColor: UIColor = {
        return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .yellow500
            } else {
                return .yellow500
            }
        }
    }()
    
    public static let primaryDarkColor: UIColor = {
        return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .yellow600
            } else {
                return .yellow600
            }
        }
    }()
    
    public static let backgroundColor: UIColor = {
        return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .gray900
            } else {
                return .white500
            }
        }
    }()
    
    public static let inverseBackgroundColor: UIColor = {
        return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .white500
            } else {
                return .gray900
            }
        }
    }()
    
    public static let shadowColor: UIColor = {
        return UIColor { (UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white500.withAlphaComponent(0.25)
            } else {
                return UIColor.gray900.withAlphaComponent(0.25)
            }
        }
    }()
    
    public static let defaultAnimationDuration = 0.1
    
}
