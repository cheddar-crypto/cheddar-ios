//
//  ContentView.swift
//  wallet
//
//  Created by Michael Miller on 8/12/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import SwiftUI


let password = "sshhhhhh"

struct ContentView: View {
    @State private var resultMessage = ""

    var body: some View {
        VStack {
            Text("mmm cheesy 🧀").padding()
            Button(action: {
                Lightning.shared.purge()
                self.resultMessage = "Directory Wiped"
            }) {
                Text("Wipe wallet")
            }.padding()
            
            Button(action: {
                Lightning.shared.start({ (error) in
                    guard error == nil else {
                           self.resultMessage = "LND start failed - \(error?.localizedDescription ?? "")"
                           return
                       }
                    
                       self.resultMessage = "LND running..."
                }) { (error) in
                    guard error == nil else {
                           self.resultMessage = "LND RPC start failed - \(error?.localizedDescription ?? "")"
                           return
                       }
                    
                       self.resultMessage = "RPC ready..."
                }
            }) {
                Text("Start LND")
            }.padding()
            
            Button(action: {
                Lightning.shared.generateSeed { (seed, error) in
                    guard error == nil else {
                        self.resultMessage = "Seed generation failed - \(error?.localizedDescription ?? "")"
                        return
                    }
                    
                    Lightning.shared.createWallet(password: password, cipherSeedMnemonic: seed) { (error) in
                        guard error == nil else {
                            self.resultMessage = "Create wallet failed - \(error?.localizedDescription ?? "")"
                            return
                        }
                        
                        self.resultMessage = seed.joined(separator: " ")
                    }
                }
            }) {
                Text("Create wallet")
            }.padding()
            
            Button(action: {
                Lightning.shared.unlockWalet(password: password) { (error) in
                    guard error == nil else {
                        self.resultMessage = "Wallet unlock failed - \(error?.localizedDescription ?? "")"
                        return
                    }
                    
                    self.resultMessage = "Unlocked"
                }
            }) {
                Text("Unlock wallet")
            }.padding()
            
            Button(action: {
                Lightning.shared.info { (info, error) in
                    guard error == nil else {
                        return self.resultMessage = "LND get info Failed - \(error?.localizedDescription ?? "")"
                    }
                    
                    self.resultMessage = info.debugDescription
                }
            }) {
                Text("Get info")
            }.padding()
            
            Button(action: {
                Lightning.shared.walletBalance { (balance, error) in
                    guard error == nil else {
                        return self.resultMessage = "LND get balance Failed - \(error?.localizedDescription ?? "")"
                    }
                    
                    self.resultMessage = "Total: \(balance.totalBalance)"
                }
            }) {
                Text("Get balance")
            }.padding()

            if !resultMessage.isEmpty {
                Text(resultMessage).font(.system(size: 10))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
