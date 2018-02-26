//
//  RegistrationViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 2/21/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegistrationViewController: UIViewController {

    let appDatabase = FIRDatabase.database().reference()
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cosmetics
        registerButton.layer.cornerRadius = 4.0
        registerButton.layer.masksToBounds = true
    }
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        SVProgressHUD.show()
        
        // 1 create user with Firebase
        FIRAuth.auth()?.createUser(withEmail: emailAddressField.text!, password: confirmPasswordField.text!, completion: { (user, error) in
            if error != nil {
                print("ERROR === \(error!)")
            } else {
                // Success
                print("Registration successful! user ID === \(user!.uid)")
                
                let newUserDict : Dictionary = ["userID": user!.uid, "firstName": self.firstNameField.text!, "emailAddress": self.emailAddressField.text!, "profileImage": "", "favorites": []] as [String : Any]
                self.appDatabase.child("users").child(user!.uid).setValue(newUserDict)
                
                let newUser : User = User(
                    userID: user!.uid,
                    firstName: self.firstNameField.text!,
                    emailAddress: self.emailAddressField.text!,
                    profileImage: UIImage(named: "icon-username")!,
                    favorites: [])
                
                // Include existing favorites in case registering with faves
                if favoritePuppies.count != 0 {
                    newUser.favorites = favoritePuppies
                }
                
                currentUser = newUser
                
                // 2 segue to rootview controller
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        })
    }
}
