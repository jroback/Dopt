//
//  ButtonViewFrame.swift
//  rescue
//
//  Created by Roback, Jerry on 9/28/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ButtonViewFrame: UIView {
    
    
    // TODO add Xib Outlets:
    
    @IBOutlet var xibButtonFrame: UIView!
    @IBOutlet weak var xibLike: UIButton!
    @IBOutlet weak var xibUnlike: UIButton!
    
    
    @IBAction func Like(_ sender: AnyObject) {
        if xibLike.tag == (sender as! UIButton).tag {
            self.xibLike.isHidden = true
            didLike(i: xibLike.tag)
        }
    }
    
    @IBAction func Unlike(_ sender: AnyObject) {
        self.xibLike.isHidden = false
        print("\(filteredPuppyDict[xibLike.tag].puppyName) Removed from Faves")
        print("\(filteredPuppyDict[xibLike.tag].puppyID)")
        print("\(filteredPuppyDict[xibLike.tag].puppyContactEmail)")
        unLike(i: xibLike.tag)
    }
    
    
    func didLike(i: Int) {
        // Alert if not logged in and first fave
        if favoritePuppies.count == 0 && currentUser == nil {
            print("Alert ==== Faves will not be saved unless logged in")
            //
            let loginAlert = UIAlertController(title: "Pup Temporarily Saved", message: "Without an account, your favorites list will be deleted upon exiting the app.", preferredStyle: .alert)
            let createAction = UIAlertAction(title: "Create Account", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            loginAlert.addAction(createAction)
            loginAlert.addAction(okAction)
            //
            HomeViewController.pushAlert(alert: loginAlert)
        }
        
        favoritePuppies.insert(filteredPuppyDict[i], at: 0)  // inserts at first position was .append(puppyDict[i])
        print("\(filteredPuppyDict[i].puppyName) Added to Faves")
        print("\(filteredPuppyDict[xibLike.tag].puppyID)")
        print("\(filteredPuppyDict[xibLike.tag].puppyContactEmail)")
        // appended to faves list based on the tag value of the button
    }
    
    func unLike(i: Int) {
        
        let index = favoritePuppies.index(where: { Puppy in
            let value = Puppy.puppyName
            return value == filteredPuppyDict[i].puppyName
        })
        if let index = index {
            favoritePuppies.remove(at: index)
            print(favoritePuppies.count)
        }
    }
    
    
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
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "ButtonViewFrame", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
// End
}
