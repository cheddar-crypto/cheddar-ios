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
    
    let randomIntObservable = Observable<Int>()
    let errorObservable = Observable<NSException>()
    
    func load() {
        
        // This is an example of a fetch to some data provider (i.e. an http api or something else)
        // and where you can place the observed response
        exampleRepo.getRandomInt(
            onSuccess: { [weak self] someInt in
                self?.randomIntObservable.value = someInt
            },
            onFailure: { [weak self] error in
                self?.errorObservable.value = error
            })
        
    }
    
}
