//
//  UIImageView.swift
//  wallet
//
//  Created by Michael Miller on 8/27/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension UIImage {
    
    func tint(_ color: UIColor) -> UIImage {
        return withRenderingMode(.alwaysTemplate).withTintColor(color)
    }
    
}
