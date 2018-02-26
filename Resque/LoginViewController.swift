//
//  LoginViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 2/23/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddressField.becomeFirstResponder()
        
        //Cosmetics
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        // Login the user
        FIRAuth.auth()?.signIn(withEmail: emailAddressField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil {
                print(error as Any)
            } else {
                // Success!
                let loggedinUserID = user?.uid
                // Fetch the user
                FIRDatabase.database().reference().child("users").child(loggedinUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let loggedinUserDict = snapshot.value as? [String: Any] {
                        // Contruct user from Snapshot
                        // TODO: Figure out image in FireBase storage and populate that URL here
                        var loggedInUser : User = User(
                            userID: (loggedinUserDict["userID"] as? String)!,
                            firstName: (loggedinUserDict["firstName"] as? String)!,
                            emailAddress: (loggedinUserDict["emailAddress"] as? String)!,
                            profileImage: UIImage(named: "icon-username")!,
                            favorites: [])
                        
                        // Store profile image URL
                        if ((loggedinUserDict["profileImage"] as? String) != nil) {
                            userProfileURL = (loggedinUserDict["profileImage"] as? String!)!
                            print(userProfileURL)
                        }
                        
                        // Contruct user faves from Snapshot
                        let firFavesArray = loggedinUserDict["favorites"] as! [Dictionary<String, Any>]
                        for fave in 0..<firFavesArray.count {
                            let favePuppy : Puppy = Puppy(
                                puppyID: (firFavesArray[fave]["puppyID"] as? Int)!,
                                puppyName: (firFavesArray[fave]["puppyName"] as? String)!,
                                puppyAge: (firFavesArray[fave]["puppyAge"] as? String)!,
                                puppyBreed: (firFavesArray[fave]["puppyBreed"] as? String)!,
                                puppyCity: (firFavesArray[fave]["puppyCity"] as? String)!,
                                puppyState: (firFavesArray[fave]["puppyState"] as? String)!,
                                puppyImage: (firFavesArray[fave]["puppyImage"] as? String)!,
                                puppySize: (firFavesArray[fave]["puppySize"] as? String)!,
                                puppySex: (firFavesArray[fave]["puppySex"] as? String)!,
                                puppyBio: (firFavesArray[fave]["puppyBio"] as? String)!,
                                puppyShelterID: (firFavesArray[fave]["puppyShelterID"] as? String)!,
                                puppyDescription: (firFavesArray[fave]["puppyDescription"] as? String)!,
                                puppyContactEmail: (firFavesArray[fave]["puppyContactEmail"] as? String)!,
                                puppyAdditionalImages: (firFavesArray[fave]["puppyAdditionalImages"] as? [String])!,
                                isFave: (firFavesArray[fave]["isFave"] as? Bool)!,
                                puppyAllOptions: (firFavesArray[fave]["puppyAllOptions"] as? [String])!)
                            
                            loggedInUser.favorites.append(favePuppy)
                        }
                        
                        // Segue to Home Controller
                        currentUser = loggedInUser
                        favoritePuppies = currentUser!.favorites
                        print("===== count \(favoritePuppies.count)")
                        
                        self.performSegue(withIdentifier: "goToHome", sender: nil)
                    }
                })
                
            }
        })
        //
    }
}
