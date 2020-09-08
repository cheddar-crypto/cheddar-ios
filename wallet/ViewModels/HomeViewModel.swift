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
    private let lightningRepo = LightningRepository()
    
    let isLoading = Observable<Bool>()
    let randomInt = Observable<Int>()
    let error = Observable<Error>()
    let resultMessage = Observable<String>()
    let walletWipe = Observable<Void>()
    let newAddress = Observable<String>()
    
    // Hardcoded values
    // TODO: Change these later
    private let nodePubKey = try! NodePublicKey("02c72b987ee75223bf3437905c8b40d224ce94e3586da9eee0fc87839ac5842ccd")
    private let hostAddress = "54.189.108.12"
    private let hostPort: UInt = 9735
    private let closeAddress = "tb1qylxttvn7wm7vsc2j36cjvmpl7nykcrzqkz6avl"
    
    func load() {
        
        isLoading.value = true
        
        // This is an example of a fetch to some data provider (i.e. an http api or something else)
        // and where you can place the observed response
        exampleRepo.getRandomInt(
            onSuccess: { [weak self] someInt in
                self?.isLoading.value = false
                self?.randomInt.value = someInt
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.error.value = error
            })
        
    }
    
    func createWallet(password: String) {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.createWallet(
            password: password,
            onSuccess: { [weak self] seed in
                self?.isLoading.value = false
                self?.resultMessage.value = seed.joined(separator: ",")
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
        
    }
    
    func unlockWallet(password: String) {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.unlockWallet(
            password: password,
            onSuccess: { [weak self] in
                self?.isLoading.value = false
                self?.resultMessage.value = "Wallet unlocked"
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
    }
    
    func openChannel() {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.openChannel(
            host: hostAddress,
            port: hostPort,
            nodePubKey: nodePubKey,
            closeAddress: closeAddress,
            onSuccess: { [weak self] message in
                self?.isLoading.value = false
                self?.resultMessage.value = message
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
    }
    
    func wipeWallet() {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.wipeWallet(
            onSuccess: { [weak self] in
                self?.isLoading.value = false
                self?.walletWipe.value = ()
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
    }
    
    func getWalletBalance() {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.getWalletBalance(
            onSuccess: { [weak self] (total, confirmed, unconfirmed) in
                self?.isLoading.value = false
                self?.resultMessage.value = "Total: \(total)\nConfirmed: \(confirmed)\nUnconfirmed: \(unconfirmed)"
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
    }
    
    func getNewAddress() {
        
        self.resultMessage.value = ""
        self.isLoading.value = true
        
        lightningRepo.getNewAddress(
            onSuccess: { [weak self] address in
                self?.isLoading.value = false
                self?.newAddress.value = address
            },
            onFailure: { [weak self] error in
                self?.isLoading.value = false
                self?.resultMessage.value = error?.localizedDescription // TODO: Change to error
            })
    }
    
}
