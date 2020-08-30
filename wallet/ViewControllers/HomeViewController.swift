//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: CheddarViewController<HomeViewModel> {
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
        viewModel.createWallet(password: self.password)
    }
    
    @objc private func unlockWallet() {
        viewModel.unlockWallet(password: self.password)
    }
    
    @objc private func newAddress() {
        viewModel.getNewAddress()
    }
    
    @objc private func showBalance() {
        viewModel.getWalletBalance()
    }
    
    @objc private func openChannel() {
        viewModel.openChannel()
    }
    
    @objc private func wipeWallet() {
        viewModel.wipeWallet()
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
    
    // This will get called when the ViewModel for this ViewController is ready to use
    // This gives us a simple place to observe all changes to the datasources
    // and can update the views accordingly as they change in real time
    override func viewModelDidLoad() {
        
        viewModel.isLoading.observe = { [weak self] isLoading in
            if (isLoading) {
                self?.showLoadingView()
            }
        }
        
        viewModel.randomInt.observe = { [weak self] randomInt in
            self?.showContentView()
        }
        
        viewModel.error.observe = { [weak self] error in
            self?.showErrorView()
        }
        
        viewModel.resultMessage.observe = { [weak self] message in
            self?.resultMessage.text = message
            self?.showContentView()
        }
        
        viewModel.newAddress.observe = { [weak self] address in
            self?.resultMessage.text = address
            UIPasteboard.general.string = address
            self?.showContentView()
        }
        
        viewModel.walletWipe.observe = { _ in
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        viewModel.load()
        
    }
    
}
