//
//  Transaction.swift
//  wallet
//
//  Created by Michael Miller on 9/16/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

struct Transaction {
    let isSent: Bool
    let amount: Double
    let message: String?
    let date: Date
}
