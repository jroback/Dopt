//
//  MenuTableViewController.swift
//  rescue
//
//  Created by Roback, Jerry on 10/18/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MenuTableViewController: UITableViewController {
    
    var settingsArray = [String]()
    var iconArray = [String]()
    
    var imagePickerHelper: ImagePickerHelper!
    var selectedProfileImage: UIImage!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileGreetingLabel: UILabel!
    @IBOutlet weak var editProfileImageButton: UIButton!
    @IBOutlet weak var logoutCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBarOffset = CGPoint(x: 0.0, y: 2.8)
        tableView.setContentOffset(statusBarOffset, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutDidTap)))
        
        let statusBarOffset = CGPoint(x: 0.0, y: 2.8)
        tableView.setContentOffset(statusBarOffset, animated: false)
        
        tableView.dataSource = self
        
        // Load current User Info
        if currentUser != nil {
            profileImageView.image = currentUser!.profileImage
            profileGreetingLabel.text = "Hey, \(currentUser!.firstName)"
        }
        
        if userProfileURL != "" {
            profileImageView.sd_setImage(with: URL(string: userProfileURL), completed: nil)
        }
        
        //Remove default row seaparator margin
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        editProfileImageButton.layer.cornerRadius = editProfileImageButton.frame.height / 2.0
        editProfileImageButton.clipsToBounds = true
        editProfileImageButton.layer.borderWidth = 1
        editProfileImageButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func logoutDidTap() {
        if currentUser != nil {
            // TODO: Add save faves params
            saveUserFaves()
            
            // TODO: Reset all screens and subiews
            try! FIRAuth.auth()!.signOut()
            currentUser = nil
            resetAppDefaults()
            //
            self.performSegue(withIdentifier: "goToWelcome", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backHome" {
            // Reset the variables
            offset = offset - count
            filteredPuppyDict = []
            puppyDict = []
        }
    }
    
    @IBAction func editProfileImageDidTap(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.selectedProfileImage = image
            
            // Save to Firebase
            let profileImageStorageDirectory = FIRStorage.storage().reference().child("profile_images").child("\(currentUser!.userID).jpg")
            if let uploadData = UIImageJPEGRepresentation(image!, 0.2) {
                profileImageStorageDirectory.put(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    } else {
                        // Success!
                        if metaData?.downloadURL()?.absoluteString != nil {
                            userProfileURL = (metaData?.downloadURL()?.absoluteString)!
                            print("URL ===== \(userProfileURL)")
                        }
                    }
                })
            }
        })
    }
    
    func resetAppDefaults() {
        favoritePuppies = []
        puppyDict = []
        filteredPuppyDict = []
        offset = 0
        photoSearchOffset = 0
        searchPhoto = nil
        isImageSearchActive = false
        breed = ""
        puppyBreed = ""
    }
    
    func saveUserFaves() {
        print("==== Faves Saved ====")
        let appDatabase = FIRDatabase.database().reference()
        
        if favoritePuppies.count != 0 {
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
        } else {
            appDatabase.child("users").child((currentUser?.userID)!).child("favorites").setValue(nil)
        }
        // Update Profile URL
        if currentUser != nil && userProfileURL != "" {
            appDatabase.child("users").child((currentUser?.userID)!).child("profileImage").setValue(userProfileURL)
        }
    }

}
