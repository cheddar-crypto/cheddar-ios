//
//  AppDelegate.swift
//  wallet
//
//  Created by Michael Miller on 8/12/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let priceRepo = PriceRepository()
//    private let eventBus = EventBus()
//    public static let onPriceChange = "onPriceChange"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Update the global price while user is navigating app
        // This will be moved to firebase at somepoint
        priceRepo.registerPriceChangeListener(
            onSuccess: { price in
                EventBus.postToMainThread(.fbPriceUpdate, sender: price)
            },
            onFailure: { error in
                // TODO
            })
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

