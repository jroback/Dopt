//
//  AppDelegate.swift
//  Resque
//
//  Created by Roback, Jerry on 12/12/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isStatusBarHidden = false
        
        // REMOVE + REPLACE WITH FIREBASE -- Test User Only
        // currentUser = testUser
        FIRApp.configure()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveUserFaves()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveUserFaves()
    }
    
    func saveUserFaves() {
        print("==== Faves Saved ====")
        let appDatabase = FIRDatabase.database().reference()
        
        if favoritePuppies.count != 0 && currentUser != nil {
            var userFavesDict = [Dictionary<String, Any>]()
            for fave in 0..<favoritePuppies.count {
                var userFave = [String : Any]()
                userFave["isFave"] = favoritePuppies[fave].isFave
                userFave["puppyAdditionalImages"] = favoritePuppies[fave].puppyAdditionalImages
                userFave["puppyAge"] = favoritePuppies[fave].puppyAge
                userFave["puppyAllOptions"] = favoritePuppies[fave].puppyAllOptions
                userFave["puppyBio"] = favoritePuppies[fave].puppyBio
                userFave["puppyBreed"] = favoritePuppies[fave].puppyBreed
                userFave["puppyCity"] = favoritePuppies[fave].puppyCity
                userFave["puppyContactEmail"] = favoritePuppies[fave].puppyContactEmail
                userFave["puppyDescription"] = favoritePuppies[fave].puppyDescription
                userFave["puppyID"] = favoritePuppies[fave].puppyID
                userFave["puppyImage"] = favoritePuppies[fave].puppyImage
                userFave["puppyName"] = favoritePuppies[fave].puppyName
                userFave["puppySex"] = favoritePuppies[fave].puppySex
                userFave["puppyShelterID"] = favoritePuppies[fave].puppyShelterID
                userFave["puppySize"] = favoritePuppies[fave].puppySize
                userFave["puppyState"] = favoritePuppies[fave].puppyState
                
                userFavesDict.append(userFave)
            }
            appDatabase.child("users").child((currentUser?.userID)!).child("favorites").setValue(userFavesDict)
        } else if currentUser != nil {
            appDatabase.child("users").child((currentUser?.userID)!).child("favorites").setValue(nil)
        }
        // Update Profile URL
        if currentUser != nil && userProfileURL != "" {
            appDatabase.child("users").child((currentUser?.userID)!).child("profileImage").setValue(userProfileURL)
        }
    }
}

