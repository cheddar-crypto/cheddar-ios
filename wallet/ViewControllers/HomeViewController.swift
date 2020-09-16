//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: CheddarViewController<HomeViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Say Cheese"
        setup()
//        updateStatus()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        subscribe()
//    }

//    private func subscribe() {
//        EventBus.onMainThread(self, eventType: .lndStateChange) { [weak self] (_) in
//            self?.updateStatus()
//        }
//    }

//    private func updateStatus() {
//        debugStatus.text = LightningStateMonitor.shared.state.debuggingStatus.joined(separator: "\n\n")
//    }

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
            self.viewModel.createWallet(password: "")
        })
        let unlockButton = addDebugButton("Unlock wallet", topAnchor: createButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.unlockWallet(password: "")
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
        let listChannelsButton = addDebugButton("List channels", topAnchor: openChannelButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.listChannels()
        })
        let payButton = addDebugButton("Pay invoice", topAnchor: listChannelsButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.payInvoice()
        })
        let wipeButton = addDebugButton("Wipe (and close) wallet", topAnchor: payButton.bottomAnchor, topConstant: 10, action: {
            self.viewModel.wipeWallet()
        })
        let requestFlowButton = addDebugButton("Launch request invoice flow", topAnchor: wipeButton.bottomAnchor, topConstant: 10, action: {
//            self.pushRequestAmount()
            Navigator.pushRequestAmount(self)
        })
        let onChainButton = addDebugButton("Launch onchain address vc", topAnchor: requestFlowButton.bottomAnchor, topConstant: 10, action: {
//            self.presentOnChainAddress()
            Navigator.showOnChainAddress(self)
        })
        let paymentFlowButton = addDebugButton("Launch LND payment flow", topAnchor: onChainButton.bottomAnchor, topConstant: 10, action: {
//            self.presentPayment()
            Navigator.pushPaymentScan(self)
        })

//        resultMessage = UILabel()
//        resultMessage.text = "..."
//        resultMessage.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(resultMessage)
//        resultMessage.topAnchor.constraint(equalTo: paymentFlowButton.bottomAnchor, constant: 20).isActive = true
//        resultMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        resultMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        resultMessage.textColor = Theme.inverseBackgroundColor
//        resultMessage.textAlignment = .center
//        resultMessage.numberOfLines = 0
//
//        debugStatus = UILabel()
//        debugStatus.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(debugStatus)
//        debugStatus.topAnchor.constraint(equalTo: resultMessage.bottomAnchor, constant: 50).isActive = true
//        debugStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        debugStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        debugStatus.textColor = Theme.inverseBackgroundColor
//        debugStatus.textAlignment = .center
//        debugStatus.numberOfLines = 0
//        debugStatus.text = "Debug status"
    }
    
    override func viewModelDidLoad() {
        
        viewModel.isLoading.observe = { [weak self] isLoading in
            if (isLoading) {
                self?.showLoadingView()
            }
        }
        
        viewModel.price.observe = { [weak self] price in
            self?.showContentView()
        }
        
        viewModel.error.observe = { [weak self] error in
            self?.showErrorView()
        }
        
        viewModel.resultMessage.observe = { [weak self] message in
//            self?.resultMessage.text = message
            self?.showContentView()
        }
        
        viewModel.newAddress.observe = { [weak self] address in
//            self?.resultMessage.text = address
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
