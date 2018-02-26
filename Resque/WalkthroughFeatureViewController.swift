//
//  WalkthroughFeatureViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 2/21/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class WalkthroughFeatureViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var featureScrollView: UIScrollView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    let feature1 : Feature = Feature(headline: "First Headline", subheadline: "First Subheadline is super funny and witty and interesting.", heroImage: UIImage(named: "no-faves-4")!)
    let feature2 : Feature = Feature(headline: "Second Headline", subheadline: "Second Subheadline is super funny and witty and interesting.", heroImage: UIImage(named: "no-faves-4")!)
    let feature3 : Feature = Feature(headline: "Third Headline", subheadline: "Third Subheadline is super funny and witty and interesting.", heroImage: UIImage(named: "no-faves-4")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        featureScrollView.delegate = self
        
        featuresArray = [feature1, feature2, feature3]
        featureScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featuresArray.count), height: view.frame.height)
        
        //Cosmetics
        getStartedButton.layer.cornerRadius = 4.0
        getStartedButton.layer.masksToBounds = true
        
        loadFeatures()
    }
    
    func loadFeatures() {
        for feature in 0..<featuresArray.count {
            let xPosition : CGFloat = self.view.bounds.width * CGFloat(feature)
            let featureView : FeatureView = FeatureView(frame: CGRect(x: xPosition , y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height))
            
            //Construct Subview
            featureView.headlineLabel.text = featuresArray[feature].headline
            featureView.subheadlineLabel.text = featuresArray[feature].subheadline
            featureView.heroImage.image = featuresArray[feature].heroImage
            
            featureScrollView.addSubview(featureView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageIndicator.currentPage = Int(page)
    }
    
    @IBAction func getStartedDidTap(_ sender: Any) {
        //TODO: Perform segue to login screen
    }
    
}
