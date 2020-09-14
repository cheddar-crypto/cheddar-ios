//
//  Strings.swift
//  wallet
//
//  Created by Michael Miller on 8/23/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

extension String {
    
    public static let defaultError = NSLocalizedString("DEFAULT_ERROR", comment: "A fallback error")
    public static let request = NSLocalizedString("REQUEST", comment: "Request")
    public static let note = NSLocalizedString("NOTE", comment: "Note")
    public static let next = NSLocalizedString("NEXT", comment: "Next")
    public static let createQR = NSLocalizedString("CREATE_QR", comment: "Create a QR code")
    public static let forLabel = NSLocalizedString("FOR", comment: "For")
    public static let requestNotePlaceholder = NSLocalizedString("NOTE_PLACEHOLDER", comment: "Placeholder for the note")
    
    public static func bitcoinCount(count: Float) -> String {
        let formatString = NSLocalizedString("BITCOIN_COUNT", comment: "A count of bitcoins")
        return String.localizedStringWithFormat(formatString, count)
    }
    
}
