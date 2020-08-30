//
//  ExampleRepository.swift
//  wallet
//
//  Created by Michael Miller on 8/23/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class ExampleRepository {
    
    // Perform fake request
    func getRandomInt(onSuccess: @escaping (Int) -> Void, onFailure: @escaping (Error) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            onSuccess(Int.random(in: 1..<100))
        }
    }
    
}
