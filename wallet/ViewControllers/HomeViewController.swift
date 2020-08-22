//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit
import SwiftUI

class HomeViewController: CheddarViewController {
    private let password = "sshhhhhh"

    private var debugStatus: UILabel!
    private var resultMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Say Cheese"
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

            self.resultMessage.text = "Total: \(balanceResponse.totalBalance)\nConfirmed: \(balanceResponse.confirmedBalance)\nUnconfirmed: \(balanceResponse.unconfirmedBalance)"
        }
    }
    
    @objc private func openChannel() {
        resultMessage.text = ""
        
        //TODO allow for passing in a convenient string like 02c72b987ee75223bf3437905c8b40d224ce94e3586da9eee0fc87839ac5842ccd@54.189.108.12:9735
        
        let nodePubKey = try! NodePublicKey("02c72b987ee75223bf3437905c8b40d224ce94e3586da9eee0fc87839ac5842ccd")
        let hostAddress = "54.189.108.12"
        let hostPort: UInt = 9735
        let closeAddress = "tb1qylxttvn7wm7vsc2j36cjvmpl7nykcrzqkz6avl"
        
        Lightning.shared.connectToNode(nodePubkey: nodePubKey, hostAddress: hostAddress, hostPort: hostPort) { [weak self] (response, error) in
            guard let self = self else { return }

            guard error == nil else {
                self.resultMessage.text = "Failed to connect to node - \(error?.localizedDescription ?? "")"
                return
            }
            
            self.resultMessage.text = "Connected to peer"
            
            
            Lightning.shared.openChannel(localFundingAmount: 20000, closeAddress: closeAddress, nodePubkey: nodePubKey) { [weak self] (response, error) in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.resultMessage.text = "Channel open failed - \(error?.localizedDescription ?? "")"
                    return
                }
                
                guard let update = response.update else {
                  return
                }
                
                switch update {
                case .chanPending(let pendingUpdate):
                    self.resultMessage.text = "Channel open pending update\nTXID: \(pendingUpdate.txid.base64EncodedString())"
                case .chanOpen(let openUpdate):
                    self.resultMessage.text = "Channel open success update"
                case .psbtFund(let onpsbtFund):
                    self.resultMessage.text = "I don't know why you would get this error"
                }
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
    
    @objc private func launchRequestInvoice() {
        presentRequestPayment()
    }
    
    @objc private func launchOnChainAddress() {
        presentOnChainAddress()
    }
    
    @objc private func launchPaymentFlow() {
        presentPayment()
    }
    
    private func addDebugButton(_ title: String, action: Selector, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitleColor(Theme.inverseBackgroundColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Fonts.sofiaPro(weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = Theme.inverseBackgroundColor.cgColor
    
        return button
    }

    private func setup() {
        let createButton = addDebugButton("Create wallet", action: #selector(createWallet), topAnchor: view.topAnchor, topConstant: 100)
        let unlockButton = addDebugButton("Unlock wallet", action: #selector(unlockWallet), topAnchor: createButton.bottomAnchor, topConstant: 10)
        let newAddressButton = addDebugButton("New address (copies to clipboard)", action: #selector(newAddress), topAnchor: unlockButton.bottomAnchor, topConstant: 10)
        let getBalanceButton = addDebugButton("Show balance", action: #selector(showBalance), topAnchor: newAddressButton.bottomAnchor, topConstant: 10)
        let openChannelButton = addDebugButton("Open channel", action: #selector(openChannel), topAnchor: getBalanceButton.bottomAnchor, topConstant: 10)
        let wipeButton = addDebugButton("Wipe (and close) wallet", action: #selector(wipeWallet), topAnchor: openChannelButton.bottomAnchor, topConstant: 10)
        let requestFlowButton = addDebugButton("Launch request invoice flow", action: #selector(launchRequestInvoice), topAnchor: wipeButton.bottomAnchor, topConstant: 10)
        let onChainButton = addDebugButton("Launch onchain address vc", action: #selector(launchOnChainAddress), topAnchor: requestFlowButton.bottomAnchor, topConstant: 10)
        let paymentFlowButton = addDebugButton("Launch LND payment flow", action: #selector(launchPaymentFlow), topAnchor: onChainButton.bottomAnchor, topConstant: 10)
        
        resultMessage = UILabel()
        resultMessage.text = "..."
        resultMessage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultMessage)
        resultMessage.topAnchor.constraint(equalTo: paymentFlowButton.bottomAnchor, constant: 20).isActive = true
        resultMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        resultMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        resultMessage.textColor = Theme.inverseBackgroundColor
        resultMessage.textAlignment = .center
        resultMessage.numberOfLines = 0
        
        debugStatus = UILabel()
        debugStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(debugStatus)
        debugStatus.topAnchor.constraint(equalTo: resultMessage.bottomAnchor, constant: 50).isActive = true
        debugStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        debugStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        debugStatus.textColor = Theme.inverseBackgroundColor
        debugStatus.textAlignment = .center
        debugStatus.numberOfLines = 0
        debugStatus.text = "Debug status"
    }
}
