//
//  PhotoMatchViewFrame.swift
//  Resque
//
//  Created by Roback, Jerry on 1/22/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class PhotoMatchViewFrame: UIView {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var confidenceCategoryLabel: UILabel!
    @IBOutlet weak var breedResultLabel: UILabel!
    @IBOutlet weak var traitContainer: UIView!
    
    var view:UIView!
    
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
        view.layer.cornerRadius = 6.0
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
    //  MAKE Top Corners match the view
        resultImageView.layer.cornerRadius = 6.0
        resultImageView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            resultImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        // Breed Label Line Spacing
        
        self.dropShadow()
        addSubview(view)
    }
    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 6
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "PhotoMatch", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
