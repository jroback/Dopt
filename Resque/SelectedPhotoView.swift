//
//  SelectedPhotoView.swift
//  Resque
//
//  Created by Roback, Jerry on 1/23/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class SelectedPhotoView: UIView {

    @IBOutlet weak var selectedPhoto: UIImageView!
    
    var view:UIView!
    
    struct ColorPallet {
        var blue = UIColor(red: 0.3176, green: 0.6549, blue: 0.9765, alpha: 1.0).cgColor
        var white = UIColor.white.cgColor
        var yellow = UIColor.yellow.cgColor
        var red = UIColor.red.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        selectedPhoto.layer.cornerRadius = (selectedPhoto.layer.frame.width * 0.85) / 2.0
        selectedPhoto.layer.masksToBounds = true
        selectedPhoto.layer.borderWidth = 1.5
        selectedPhoto.layer.borderColor = ColorPallet.init().white
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "SelectedPhoto", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
