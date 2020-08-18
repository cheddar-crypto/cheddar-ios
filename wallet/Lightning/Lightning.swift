//
//  Lightning.swift
//  
//
//  Created by Jason van den Berg on 2020/08/02.
//

import Foundation

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
    
    func start(_ completion: @escaping (Error?) -> Void, onRpcReady: @escaping (Error?) -> Void) {
        print("LND Start Request")
        
        //Delete previous config if it exists
        try? FileManager.default.removeItem(at: confFile)
        //Copy new config into LND directory
        do {
            try FileManager.default.copyItem(at: Bundle.main.bundleURL.appendingPathComponent(confName), to: confFile)
        } catch {
            return completion(error)
        }
        
        let args = "--lnddir=\(storage.path)"

        print(args)

        LndmobileStart(args, LndGenericCallback(completion), LndGenericCallback(onRpcReady))
    }
    
    func stop(_ completion: @escaping (Error?) -> Void) {
        print("LND Stop Request")

        do {
            let request = try Lnrpc_StopRequest().serializedData()
            LndmobileStopDaemon(request, LndGenericCallback(completion))
            completion(nil) //TODO figure out why callback is never hit by LndGenericCallback
        } catch {
            completion(error)
        }
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

    func walletBalance(_ completion: @escaping (Lnrpc_WalletBalanceResponse, Error?) -> Void) {
        do {
            LndmobileWalletBalance(try Lnrpc_WalletBalanceRequest().serializedData(), WalletBalanceCallback(completion))
        } catch {
            completion(Lnrpc_WalletBalanceResponse(), error)
        }
    }
    
    func info(_ completion: @escaping (Lnrpc_GetInfoResponse, Error?) -> Void) {
        do {
            LndmobileGetInfo(try Lnrpc_GetInfoRequest().serializedData(), GetInfoCallback(completion))
        } catch {
            completion(Lnrpc_GetInfoResponse(), error)
        }
    }
}

//Utils
extension Lightning {
    func purge() {
        //TODO ensure testnet only
        print("WARNING: removing existing LND directory")
        try! FileManager.default.removeItem(at: storage)
    }
}
