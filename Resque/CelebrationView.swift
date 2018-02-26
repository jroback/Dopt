//
//  CelebrationView.swift
//  Resque
//
//  Created by Roback, Jerry on 1/17/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

@IBDesignable
class CelebrationView: UIView {

    // FRAME Outlets:
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var confettitLayerImage: UIImageView!
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: UIButton!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    //
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
        loadGifs()
        primaryActionButton.layer.cornerRadius = 4.0
        primaryActionButton.clipsToBounds = true
        secondaryActionButton.layer.cornerRadius = 4.0
        secondaryActionButton.layer.borderWidth = 1.0
        secondaryActionButton.layer.borderColor = UIColor.white.cgColor
        secondaryActionButton.clipsToBounds = true
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        addSubview(view)
    }
    
    func loadGifs() {
        heroImage.loadGif(name: "celebrate")
        confettitLayerImage.loadGif(name: "confetti")
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "CelebrationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
