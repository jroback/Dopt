//
//  feature.swift
//  Resque
//
//  Created by Roback, Jerry on 2/21/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import Foundation

var featuresArray : [Feature] = [Feature]()

class Feature {
    var headline : String
    var subheadline : String
    var heroImage : UIImage
    
    init(headline: String, subheadline: String, heroImage: UIImage) {
        self.headline = headline
        self.subheadline = subheadline
        self.heroImage = heroImage
    }
}
