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
    public static let done = NSLocalizedString("DONE", comment: "Done")
    public static let createQR = NSLocalizedString("CREATE_QR", comment: "Create a QR code")
    public static let forLabel = NSLocalizedString("FOR", comment: "For")
    public static let copy = NSLocalizedString("COPY", comment: "Copy")
    public static let pasteInvoice = NSLocalizedString("PASTE_LND_INVOICE", comment: "Paste Invoice")
    public static let pasteBitcoinAddress = NSLocalizedString("PASTE_BITCOIN_ADDRESS", comment: "Paste Address")
    public static let requestNotePlaceholder = NSLocalizedString("NOTE_PLACEHOLDER", comment: "Placeholder for the note")
    public static let seeBitcoinAddress = NSLocalizedString("SEE_BITCOIN_ADDRESS", comment: "See the bitcoin address for wallet")
    public static let youSent = NSLocalizedString("TX_YOU_SENT", comment: "You sent")
    public static let youReceived = NSLocalizedString("TX_YOU_RECEIVED", comment: "You received")
    public static let scanAddressTitle = NSLocalizedString("SCAN_ADDRESS_TITLE", comment: "Scan Address")
    public static let requestCameraAccess = NSLocalizedString("ACCESS_CAMERA", comment: "Request Camera Access")
    public static let requestCameraAccessTitle = NSLocalizedString("ACCESS_CAMERA_DESCRIPTION", comment: "Request Camera Access title")
    public static let pay = NSLocalizedString("PAY", comment: "Pay")
    public static let to = NSLocalizedString("TO", comment: "To")
    public static let swipeToSend = NSLocalizedString("SWIPE_TO_SEND", comment: "Swipe to send")
    public static let paymentSent = NSLocalizedString("PAYMENT_SENT", comment: "Payment Sent")
    
    // TODO: Support satoshis
    public static func bitcoinCount(_ count: Double) -> String {
        let str = NSLocalizedString("BITCOIN_COUNT", comment: "A count of bitcoins")
        return String.localizedStringWithFormat(str, Float(count), count.toBitcoins())
    }
    
}
