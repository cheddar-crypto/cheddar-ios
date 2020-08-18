//
//  LndCallbacks.swift
//  PayUp
//
//  Created by Jason van den Berg on 2020/08/03.
//  Copyright © 2020 Jason van den Berg. All rights reserved.
//

import Foundation

extension Lightning {
    // MARK: LND Start
    class LndGenericCallback: NSObject, LndmobileCallbackProtocol {
        let completion: (Error?) -> Void

        init(_ completion: @escaping (Error?) -> Void) {
            let startedOnMainThread = Thread.current.isMainThread
            self.completion = { error in
                
                if startedOnMainThread {
                    DispatchQueue.main.async { completion(error) }
                } else {
                    completion(error)
                }
            }
        }
        
        func onResponse(_ p0: Data?) {
            completion(nil)
        }

        func onError(_ p0: Error?) {
            completion(p0 ?? LightningError.unknownStart)
        }
    }
    
    class GenerateSeedCallback: NSObject, LndmobileCallbackProtocol {
        private var completion: ([String], Error?) -> Void

        init(_ completion: @escaping ([String], Error?) -> Void) {
            let startedOnMainThread = Thread.current.isMainThread
            self.completion = { (seed, error) in
                if startedOnMainThread {
                    DispatchQueue.main.async { completion(seed, error) }
                } else {
                    completion(seed, error)
                }
            }
        }

        func onResponse(_ p0: Data?) {
            guard let data = p0 else {
                completion([], LightningError.missingResponse)
                return
            }
        
            do {
                let response = try Lnrpc_GenSeedResponse(serializedData: data)
                completion(response.cipherSeedMnemonic, nil)
            } catch {
                completion([], LightningError.rpc)
            }
        }

        func onError(_ p0: Error?) {
            completion([], p0)
        }
    }
    
    class WalletBalanceCallback: NSObject, LndmobileCallbackProtocol {
        private var completion: (Lnrpc_WalletBalanceResponse, Error?) -> Void

        init(_ completion: @escaping (Lnrpc_WalletBalanceResponse, Error?) -> Void) {
            let startedOnMainThread = Thread.current.isMainThread
            self.completion = { (balance, error) in
                if startedOnMainThread {
                    DispatchQueue.main.async { completion(balance, error) }
                } else {
                    completion(balance, error)
                }
            }
        }

        func onResponse(_ p0: Data?) {
            guard let data = p0 else {
                completion(Lnrpc_WalletBalanceResponse(), nil)
                return
            }
        
            do {
                completion(try Lnrpc_WalletBalanceResponse(serializedData: data), nil)
            } catch {
                completion(Lnrpc_WalletBalanceResponse(), error)
            }
        }

        func onError(_ p0: Error?) {
            completion(Lnrpc_WalletBalanceResponse(), p0)
        }
    }
    
    class GetInfoCallback: NSObject, LndmobileCallbackProtocol {
        private var completion: (Lnrpc_GetInfoResponse, Error?) -> Void

        init(_ completion: @escaping (Lnrpc_GetInfoResponse, Error?) -> Void) {
            let startedOnMainThread = Thread.current.isMainThread
            self.completion = { (info, error) in
                if startedOnMainThread {
                    DispatchQueue.main.async { completion(info, error) }
                } else {
                    completion(info, error)
                }
            }
        }

        func onResponse(_ p0: Data?) {
            guard let data = p0 else {
                completion(Lnrpc_GetInfoResponse(), LightningError.missingResponse)
                return
            }
        
            do {
                completion(try Lnrpc_GetInfoResponse(serializedData: data), nil)
            } catch {
                completion(Lnrpc_GetInfoResponse(), error)
            }
        }

        func onError(_ p0: Error?) {
            completion(Lnrpc_GetInfoResponse(), p0)
        }
    }
}
