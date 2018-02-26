//
//  User.swift
//  Resque
//
//  Created by Roback, Jerry on 1/17/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import Foundation

var currentUser : User?

class User{
    var userID : String
    var firstName : String
    var emailAddress : String
    var profileImage : UIImage
    var favorites : [Puppy]
    
    init(userID: String, firstName: String, emailAddress: String, profileImage: UIImage, favorites: [Puppy]) {
        
        self.userID = userID
        self.firstName = firstName
        self.emailAddress = emailAddress
        self.profileImage = profileImage
        self.favorites = favorites
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
}

// TEST User for testing only pre-Firebase
let testUser = User(
    userID: "1abcdef",
    firstName: "Jerry",
    emailAddress: "robackjerry@gmail.com",
    profileImage: UIImage(named: "Jerry")!,
    favorites: [])


