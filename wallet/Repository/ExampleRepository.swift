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
    func getBoolean(onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (NSException) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            onSuccess(true)
        }
    }
    
}
