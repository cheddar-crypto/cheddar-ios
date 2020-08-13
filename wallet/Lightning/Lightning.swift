//
//  Lightning.swift
//  
//
//  Created by Jason van den Berg on 2020/08/02.
//

import Foundation

struct LndWalletBalance {
    let total: Int
    let confirmed: Int
    let unconfirmed: Int
}

class Lightning {
    static let shared = Lightning()
    
    enum LightningError: Error {
        case unknownStart
        case missingResponse
        case rpc
        case invalidPassword
    }
    
    private var storage: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directory = documentsDirectory.appendingPathComponent("lnd")
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            try! FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true)
        }
        
        return directory
    }
    
    private let confName = "lnd.conf"
    
    private var confFile: URL {
        return storage.appendingPathComponent(confName)
    }
    
    //Ensure it stays a singleton
    private init() {}
    
    func start(_ completion: @escaping (Error?) -> Void) {
        print("LND Start Request")
        
        do {
            try FileManager.default.copyItem(at: Bundle.main.bundleURL.appendingPathComponent(confName), to: confFile)
        } catch {
            print("Conf already exists")
        }
        
        let args = "--lnddir=\(storage.path)"

        LndmobileStart(args, LndGenericCallback(completion), nil)
    }
    
    func generateSeed(_ completion: @escaping ([String], Error?) -> Void) {
        do {
            let request = try Lnrpc_GenSeedRequest().serializedData()
            LndmobileGenSeed(request, GenerateSeedCallback(completion))
        } catch {
            completion([], error)
        }
    }
   
    func createWallet(password: String, cipherSeedMnemonic: [String], completion: @escaping (Error?) -> Void) {
        guard let passwordData = password.data(using: .utf8) else {
            return completion(LightningError.invalidPassword)
        }
        
        var request = Lnrpc_InitWalletRequest()
        request.cipherSeedMnemonic = cipherSeedMnemonic
        request.walletPassword = passwordData
        
        do {
            LndmobileInitWallet(try request.serializedData(), LndGenericCallback(completion))
        } catch {
            return completion(error)
        }
    }
    
    func unlockWalet(password: String, completion: @escaping (Error?) -> Void) {
        guard let passwordData = password.data(using: .utf8) else {
            return completion(LightningError.invalidPassword)
        }
        
        var request = Lnrpc_UnlockWalletRequest()
        request.walletPassword = passwordData
        
        do {
            LndmobileUnlockWallet(try request.serializedData(), LndGenericCallback(completion))
        } catch {
            return completion(error)
        }        
    }

    func walletBalance(_ completion: @escaping (LndWalletBalance, Error?) -> Void) {
        do {
            let request = try Lnrpc_WalletBalanceRequest().serializedData()
            LndmobileWalletBalance(request, WalletBalanceCallback(completion))
        } catch {
            completion(LndWalletBalance(total: 0, confirmed: 0, unconfirmed: 0), error)
        }
    }
}

//Utils
extension Lightning {
    func purge() {
        //TODO ensure testnet only
        try! FileManager.default.removeItem(at: storage)
    }
}
