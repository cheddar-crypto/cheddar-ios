//
//  HomeViewModel.swift
//  wallet
//
//  Created by Michael Miller on 8/23/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import Foundation

class HomeViewModel: ViewModel {
    
    private let exampleRepo = ExampleRepository()
    
    let exampleData = Observable<Bool>()
    let exampleError = Observable<NSException>()
    
    func load() {
        
        // This is an example of a fetch to some data provider (i.e. an http api or something else)
        // and where you can place the observed response
        exampleRepo.getBoolean(
            onSuccess: { [weak self] someBoolean in
                self?.exampleData.value = someBoolean
            },
            onFailure: { [weak self] error in
                self?.exampleError.value = error
            })
        
    }
    
}
