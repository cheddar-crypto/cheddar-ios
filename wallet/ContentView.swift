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
                Lightning.shared.start { (error) in
                    guard error == nil else {
                        self.resultMessage = "LND start failed - \(error?.localizedDescription ?? "")"
                        return
                    }
                 
                    self.resultMessage = "LND running..."
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
                Lightning.shared.walletBalance { (balance, error) in
                    guard error == nil else {
                        return self.resultMessage = "LND get balance Failed - \(error?.localizedDescription ?? "")"
                    }
                    
                    self.resultMessage = "Confirmed: \(balance.confirmed)\nTotal: \(balance.total)\nUnconfirmed: \(balance.unconfirmed)"
                }
            }) {
                Text("Show balance")
            }.padding()

            if !resultMessage.isEmpty {
                Text(resultMessage).font(.body)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
