//
//  Misc.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

extension String {
    
    func toQR(scale: CGFloat = 15.0) -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        // Create the filter and transform it's scale
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    var isLightningInvoice: Bool {
        // TODO: Add functionality
        return self.contains("lightning:")
    }
    
    var isBitcoinAddress: Bool {
        // TODO: Add functionality
        return self.contains("bitcoin:")
    }
    
}

extension Date {
    
    func toTimeAgo() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return String(format: NSLocalizedString("SECONDS_AGO", comment: "Seconds ago"), String(diff))
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return String(format: NSLocalizedString("MINUTES_AGO", comment: "Minutes ago"), String(diff))
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return String(format: NSLocalizedString("HOURS_AGO", comment: "Hours ago"), String(diff))
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return String(format: NSLocalizedString("DAYS_AGO", comment: "Days ago"), String(diff))
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return String(format: NSLocalizedString("WEEKS_AGO", comment: "Weeks ago"), String(diff))
        
    }
    
}
