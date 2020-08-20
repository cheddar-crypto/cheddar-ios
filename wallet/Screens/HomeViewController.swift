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
    
    @objc private func newAddress() {
        resultMessage.text = ""
        Lightning.shared.newAddress { [weak self] (address, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                self.resultMessage.text = "New address failed - \(error?.localizedDescription ?? "")"
                return
            }
            
            self.resultMessage.text = address
            UIPasteboard.general.string = address
        }
    }
    
    @objc private func showBalance() {
        resultMessage.text = ""
        
        Lightning.shared.walletBalance { [weak self] (balanceResponse, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                self.resultMessage.text = "Wallet balance failed - \(error?.localizedDescription ?? "")"
                return
            }
            
            self.resultMessage.text = "Total: \(balanceResponse.totalBalance)\nConfirmed: \(balanceResponse.confirmedBalance)\nUnconfirmed: \(balanceResponse.unconfirmedBalance)\n"
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
    
    private func addDebugButton(_ title: String, action: Selector, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    
        return button
    }

    private func setup() {
        let createButton = addDebugButton("Create wallet", action: #selector(createWallet), topAnchor: view.topAnchor, topConstant: 100)
        let unlockButton = addDebugButton("Unlock wallet", action: #selector(unlockWallet), topAnchor: createButton.bottomAnchor, topConstant: 10)
        let newAddressButton = addDebugButton("New address (copies to clipboard)", action: #selector(newAddress), topAnchor: unlockButton.bottomAnchor, topConstant: 10)
        let getBalanceButton = addDebugButton("Show balance", action: #selector(showBalance), topAnchor: newAddressButton.bottomAnchor, topConstant: 10)
        let wipeButton = addDebugButton("Wipe (and close) wallet", action: #selector(wipeWallet), topAnchor: getBalanceButton.bottomAnchor, topConstant: 10)
        
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
        debugStatus.topAnchor.constraint(equalTo: resultMessage.bottomAnchor, constant: 50).isActive = true
        debugStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        debugStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        debugStatus.textColor = .white //TODO move to theme
        debugStatus.textAlignment = .center
        debugStatus.numberOfLines = 0
        debugStatus.text = "Debug status"
    }
}
