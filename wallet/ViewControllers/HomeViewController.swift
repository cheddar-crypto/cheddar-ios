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
    
    private func addDebugButton(_ title: String, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat, action: @escaping () -> Void) -> CheddarButton {
        let button = CheddarButton(action: action)
        button.title = title
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CGFloat(32)).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return button
    }

    private func setup() {
        
        let createButton = addDebugButton("Create wallet", topAnchor: view.topAnchor, topConstant: 10, action: {
            self.viewModel.createWallet(password: self.password)
        })
        let unlockButton = addDebugButton("Unlock wallet", topAnchor: createButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.unlockWallet(password: self.password)
        })
        let newAddressButton = addDebugButton("New address (copies to clipboard)", topAnchor: unlockButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.getNewAddress()
        })
        let getBalanceButton = addDebugButton("Show balance", topAnchor: newAddressButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.getWalletBalance()
        })
        let openChannelButton = addDebugButton("Open channel", topAnchor: getBalanceButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.openChannel()
        })
        let wipeButton = addDebugButton("Wipe (and close) wallet", topAnchor: openChannelButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.wipeWallet()
        })
        let requestFlowButton = addDebugButton("Launch request invoice flow", topAnchor: wipeButton.bottomAnchor, topConstant: 10, action: {
            self.presentRequestPayment()
        })
        let onChainButton = addDebugButton("Launch onchain address vc", topAnchor: requestFlowButton.bottomAnchor, topConstant: 10, action: {
            self.presentOnChainAddress()
        })
        let paymentFlowButton = addDebugButton("Launch LND payment flow", topAnchor: onChainButton.bottomAnchor, topConstant: 10, action: {
            self.presentPayment()
        })
        
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
