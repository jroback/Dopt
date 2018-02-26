//
//  FavoritesCollectionViewCell.swift
//  rescue
//
//  Created by Roback, Jerry on 10/16/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var puppyImageView: UIImageView!
    @IBOutlet weak var puppyNameLabel: UILabel!
    @IBOutlet weak var faveLikeButton: UIButton!
    
    var fave: Puppy! {
        didSet {
            if fave.puppyImage.count > 1 {
                self.puppyImageView.sd_setImage(with: URL(string: fave.puppyImage))
            } else {
                self.puppyImageView.image = UIImage(named: "pizza-placeholder")
            }
            self.puppyNameLabel.text = fave.puppyName
            
            self.contentView.layer.cornerRadius = 4.0
            self.contentView.layer.masksToBounds = true
            
            //Drop shadow
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = 1
        }
    }
    
    @IBAction func unlikeDidTap(_ sender: Any) {
        if favoritePuppies.contains(self.fave) {
            // find the index location
            let index = favoritePuppies.index(of: self.fave)
            favoritePuppies.remove(at: index!)
        }
    }
}
