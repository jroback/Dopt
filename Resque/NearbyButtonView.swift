//
//  NearbyButtonView.swift
//  Resque
//
//  Created by Roback, Jerry on 2/5/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class NearbyButtonView: UIView {

    var view:UIView!
    
    @IBOutlet weak var nearbyCountButton: UIButton!
    
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
        nearbyCountButton.layer.cornerRadius = nearbyCountButton.bounds.height / 2.0
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "NearbyButtonView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    // End
}
