//
//  PizzaModel.swift
//  rescue
//
//  Created by Roback, Jerry on 9/24/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import Foundation

var favoritePuppies = [Puppy]()
var puppyDict = [Puppy]()
var filteredPuppyDict = [Puppy]()

class Puppy {
    var puppyID : Int
    var puppyName : String
    var puppyAge : String
    var puppyBreed : String
    var puppyCity : String
    var puppyState : String
    var puppyImage : String
    var puppySize : String
    var puppySex : String
    var puppyBio : String
    var puppyShelterID : String
    var puppyDescription : String?
    var puppyContactEmail : String
    var puppyAdditionalImages : [String]
    var puppyAllOptions : [String]
    var isFave : Bool
    
    init(puppyID: Int, puppyName: String, puppyAge: String, puppyBreed: String, puppyCity: String, puppyState: String, puppyImage: String, puppySize: String, puppySex: String, puppyBio: String, puppyShelterID: String, puppyDescription: String?, puppyContactEmail: String, puppyAdditionalImages: [String], isFave: Bool, puppyAllOptions: [String]) {
        self.puppyID = puppyID
        self.puppyName = puppyName.capitalized
        self.puppyAge = puppyAge.capitalized
        self.puppyBreed = puppyBreed.capitalized
        self.puppyCity = puppyCity.capitalized
        self.puppyState = puppyState
        self.puppyImage = puppyImage
        self.puppySize = puppySize
        self.puppySex = puppySex
        self.puppyBio = puppyBio
        self.puppyShelterID = puppyShelterID
        self.puppyDescription = puppyDescription
        self.puppyContactEmail = puppyContactEmail
        self.puppyAdditionalImages = puppyAdditionalImages
        self.puppyAllOptions = puppyAllOptions
        self.isFave = isFave
    }
}

extension Puppy: Equatable {
    static func == (lhs: Puppy, rhs: Puppy) -> Bool {
        return lhs.puppyID == rhs.puppyID
    }
}


