//
//  EmptyStateFrame.swift
//  Resque
//
//  Created by Roback, Jerry on 1/12/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

@IBDesignable
class EmptyStateFrame: UIView {

    // Frame Outlets:
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
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
        actionButton.layer.cornerRadius = 4.0
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "EmptyStateFrame", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
