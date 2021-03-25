//
//  AppDelegate.swift
//  Beautify
//
//  Created by Артем Маков on 08.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      FirebaseConfiguration.shared.setLoggerLevel(.min)
      FirebaseApp.configure()
        
      GMSServices.provideAPIKey("AIzaSyDTmEH7BdvvdHzC3r_2A7or22DPjKXjPvU")

      GMSPlacesClient.provideAPIKey("AIzaSyDTmEH7BdvvdHzC3r_2A7or22DPjKXjPvU")

      if currentUser.id == nil { FBAuthentication.shared.signOutUser { (_, _) in } }
        
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

