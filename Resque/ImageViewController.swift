//
//  ImageViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 12/18/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
    
    @IBOutlet weak var heroImage: UIImageView!
    
    var image : UIImage? {
        didSet{
            self.heroImage?.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heroImage.image = image
    }

}
