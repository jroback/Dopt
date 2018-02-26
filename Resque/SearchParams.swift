//
//  SearchParams.swift
//  Resque
//
//  Created by Roback, Jerry on 12/31/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import Foundation

//Search Parameters
var count = 15
var format = "json"
var output = "basic"
var animal = "dog"


// Location
var searchRadius = "50" // in miles
var zipCode = "60613"
var manualZipCode = false


// User
var userProfileURL : String = ""

// Dogs
var breed : String = ""
var age = ""
var genderArray = ["F", "M", ""]
var ageArray = ["Baby", "Young", "Adult", "Senior", ""]
var searchSex = ""
var selectedSizeArray : [String] = ["S", "M", "L", "XL", ""]
var breedSize = ""
var puppyBreed = ""
var selectedBreeds : [String] = []

// Photo Search
var searchPhoto : UIImage?
var isImageSearchActive : Bool?
var breedConfidencePercentage : Int = 0
var breedName : String = ""
var breedHeroImage : String = ""
var breedDescription : String = ""
var breedPersonality : String = ""
var breedTraits = [String]()
