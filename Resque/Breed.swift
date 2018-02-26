//
//  Breed.swift
//  Resque
//
//  Created by Roback, Jerry on 2/3/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import Foundation

class DogBreed {
    var breedID : Int
    var breedName : String
    var breedDisplayName : String
    var breedImage : String
    var breedDescription : String?
    var breedPersonality : [String]
    
    init(breedID: Int, breedName: String, breedDisplayName: String, breedImage: String, breedDescription: String?, breedPersonality: [String]) {
        self.breedID = breedID
        self.breedName = breedName.capitalized
        self.breedDisplayName = breedDisplayName
        self.breedImage = breedImage
        self.breedDescription = breedDescription
        self.breedPersonality = breedPersonality
    }
}
