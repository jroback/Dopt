//
//  WelcomeViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 2/21/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cosmetics
        createAccountButton.layer.cornerRadius = 4.0
        createAccountButton.layer.masksToBounds = true
        createAccountButton.layer.borderWidth = 1.0
        createAccountButton.layer.borderColor = createAccountButton.backgroundColor?.cgColor
        
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1.0
    }
}
