//
//  RequestViewModel.swift
//  wallet
//
//  Created by Michael Miller on 8/30/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class RequestViewModel: ViewModel {
    
    let amount = Observable<Double>()
    let note = Observable<String?>()
    
}
