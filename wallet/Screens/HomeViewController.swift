//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private let password = "sshhhhhh"

    private var debugStatus: UILabel!
    private var resultMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Say Cheese"
        themeSetup()
        setup()
        updateStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribe()
    }
    
    private func subscribe() {
        EventBus.onMainThread(self, eventType: .lndStateChange) { [weak self] (_) in
            self?.updateStatus()
        }
    }
    
    private func updateStatus() {
        debugStatus.text = LightningStateMonitor.shared.state.debuggingStatus.joined(separator: "\n\n")
    }
    
    @objc private func createWallet() {
        resultMessage.text = ""
        
        Lightning.shared.generateSeed { [weak self] (seed, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                self.resultMessage.text = "Seed generation failed - \(error?.localizedDescription ?? "")"
                return
            }
            
            Lightning.shared.createWallet(password: self.password, cipherSeedMnemonic: seed) { [weak self] (error) in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.resultMessage.text = "Create wallet failed - \(error?.localizedDescription ?? "")"
                    return
                }
                
                self.resultMessage.text = seed.joined(separator: " ")
            }
        }
    }
    
    @objc private func unlockWallet() {
        resultMessage.text = ""
        Lightning.shared.unlockWalet(password: password) { [weak self] (error) in
            guard let self = self else { return }
            
            guard error == nil else {
                self.resultMessage.text = "Wallet unlock failed - \(error?.localizedDescription ?? "")"
                return
            }
        }
    }
    
    @objc private func wipeWallet() {
        Lightning.shared.stop { (error) in
            Lightning.shared.purge()
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }

    private func setup() {
        let createButton = UIButton()
        createButton.setTitle("Create wallet", for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createButton.addTarget(self, action: #selector(createWallet), for: .touchUpInside)
        createButton.layer.cornerRadius = 15
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.white.cgColor
        
        let unlockButton = UIButton()
        unlockButton.setTitle("Unlock wallet", for: .normal)
        unlockButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unlockButton)
        unlockButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 10).isActive = true
        unlockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        unlockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        unlockButton.addTarget(self, action: #selector(unlockWallet), for: .touchUpInside)
        unlockButton.layer.cornerRadius = 15
        unlockButton.layer.borderWidth = 1
        unlockButton.layer.borderColor = UIColor.white.cgColor
        
        let wipeButton = UIButton()
        wipeButton.setTitle("Wipe (and close) wallet", for: .normal)
        wipeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wipeButton)
        wipeButton.topAnchor.constraint(equalTo: unlockButton.bottomAnchor, constant: 10).isActive = true
        wipeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        wipeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        wipeButton.addTarget(self, action: #selector(wipeWallet), for: .touchUpInside)
        wipeButton.layer.cornerRadius = 15
        wipeButton.layer.borderWidth = 1
        wipeButton.layer.borderColor = UIColor.white.cgColor
        
        resultMessage = UILabel()
        resultMessage.text = "..."
        resultMessage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultMessage)
        resultMessage.topAnchor.constraint(equalTo: wipeButton.bottomAnchor, constant: 20).isActive = true
        resultMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        resultMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        resultMessage.textColor = .white //TODO move to theme
        resultMessage.textAlignment = .center
        resultMessage.numberOfLines = 0
        
        debugStatus = UILabel()
        debugStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(debugStatus)
        debugStatus.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        debugStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        debugStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        debugStatus.textColor = .white //TODO move to theme
        debugStatus.textAlignment = .center
        debugStatus.numberOfLines = 0
        debugStatus.text = "Debug status"
    }
}
