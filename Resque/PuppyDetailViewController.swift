//
//  PuppyDetailViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 12/14/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
import Alamofire
import SwiftyJSON
import MapKit

class PuppyDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, MKMapViewDelegate {
    
    var puppy : Puppy!
    var shelterParams = [String : String]()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var srollView: UIScrollView!
    
    @IBOutlet weak var puppyDetailImageView: UIImageView!
  
    @IBOutlet weak var puppyLikeButton: UIButton!
    @IBOutlet weak var ageAndBreedLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var adoptButton: UIButton!
    @IBOutlet weak var adoptbuttonBottom: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var puppySizeLabel: UILabel!
    @IBOutlet weak var puppyShotsLabel: UILabel!
    @IBOutlet weak var puppAlteredLabel: UILabel!
    @IBOutlet weak var puppySexLabel: UILabel!
    
    @IBOutlet weak var puppySizeIcon: UIImageView!
    @IBOutlet weak var puppyShotsIcon: UIImageView!
    @IBOutlet weak var puppyAlteredIcon: UIImageView!
    @IBOutlet weak var puppySexIcon: UIImageView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    // SHELTER VARIABLES
    @IBOutlet weak var shelterVisitLabel: UILabel!
    @IBOutlet weak var shelterNameLabel: UILabel!
    @IBOutlet weak var shelterAddressLabel: UILabel!
    @IBOutlet weak var shelterCityStateLabel: UILabel!
    @IBOutlet weak var shelterMapView: MKMapView!
    var shelterLat : Double = 30.7193
    var shelterLong : Double = -74.0045
    var shelterName = ""
    var shelterPhone : String = ""
    
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func viewWillAppear(_ animated: Bool) {
        shelterParams = ["key" : petFinderSecret, "id" : puppy.puppyShelterID, "format" : format, "jsonp" : jsonp]
        
        self.getData(url: petFinderShelterPath, parameters: shelterParams)
    }
    
    let regionRadius: CLLocationDistance = 1600 // 1 miles in meters
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        shelterMapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // MAP LOCATION
        
        shelterMapView.delegate = self
        let initialLocation = CLLocation(latitude: shelterLat, longitude: shelterLong)
        centerMapOnLocation(location: initialLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        annotation.title = shelterName
        
        shelterMapView.addAnnotation(annotation)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Map
        
        // Set Shelter Location
        
        print("ADDITONAL IMAGES === \(puppy.puppyAdditionalImages)")
        
        srollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        viewHeightConstraint.constant = contentView.bounds.height
        
        navigationItem.title = puppy.puppyName
        shelterVisitLabel.text = "Visit \(puppy.puppyName)"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //Add Share Button icon to NavBar
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidTap))
        
        // COSMETICS
        adoptButton.layer.cornerRadius = 3.0
        adoptButton.clipsToBounds = true
        adoptbuttonBottom.layer.cornerRadius = 2.0
        adoptbuttonBottom.clipsToBounds = true
        callButton.layer.cornerRadius = 2.0
        callButton.clipsToBounds = true

        
        if favoritePuppies.contains(puppy) {
            puppyLikeButton.setImage(UIImage(named: "Like-solid"), for: .normal)
        } else {
            puppyLikeButton.setImage(UIImage(named: "like-empty"), for: .normal)
        }
        
        //Hide page controll if only 1 image
        if puppy.puppyAdditionalImages.count <= 1 {
            pageControll.hidesForSinglePage = true
        }
        
        loadPuppyImages()
        loadPuppyData()
    }
    
    func loadPuppyImages() {
    puppyDetailImageView.sd_setImage(with: URL(string: puppy.puppyImage))
    }
    
    func loadPuppyData() {
        if puppy.puppyDescription == "" {
            descriptionText.text = "Sorry, \(puppy.puppyName) has no description."
        } else {
            descriptionText.text = puppy.puppyDescription
        }
        
        ageAndBreedLabel.text = "\(puppy.puppyAge) \(puppy.puppyBreed)"
        cityAndStateLabel.text = "\(puppy.puppyCity), \(puppy.puppyState)"
        
        // SEX
        if puppy.puppySex == "M" {
            puppySexLabel.text = "Male"
            puppySexIcon.image = UIImage(named: "icon-male")
        } else {
            puppySexLabel.text = "Female"
            puppySexIcon.image = UIImage(named: "icon-female")
        }
        
        
        // SHOTS | Housetrained
        if puppy.puppyAllOptions.contains("housetrained") {
            puppyShotsLabel.text = "Trained"
            puppyShotsIcon.image = UIImage(named: "housetrain-icon")
        } else if puppy.puppyAllOptions.contains("hasShots") {
            puppyShotsLabel.text = "Has Shots"
            puppyShotsIcon.image = UIImage(named: "shots-icon")
        } else {
            puppyShotsLabel.text = "No Shots"
            puppyShotsIcon.image = UIImage(named: "no-shots-icon")
        }
        
        
        // Altered
        if puppy.puppyAllOptions.contains("altered") {
            puppyAlteredIcon.image = UIImage(named: "altered-icon")
            if puppy.puppySex == "M" {
                puppAlteredLabel.text = "Neutered"
            } else {
                puppAlteredLabel.text = "Spayed"
            }
        } else {
            puppAlteredLabel.text = "Not Altered"
            puppyAlteredIcon.image = UIImage(named: "not-altered-icon")
        }
        
        
        // SIZE
        if puppy.puppySize == "S" {
            puppySizeLabel.text = "Size: S"
            puppySizeIcon.image = UIImage(named: "dog-small-icon")
        } else if puppy.puppySize == "M" {
            puppySizeLabel.text = "Size: M"
            puppySizeIcon.image = UIImage(named: "dog-medium-icon")
        } else if puppy.puppySize == "L" {
            puppySizeLabel.text = "Size: L"
            puppySizeIcon.image = UIImage(named: "size-large-icon")
        } else {
            puppySizeLabel.text = "Size: XL"
            puppySizeIcon.image = UIImage(named: "size-large-icon")
        }
    }
    
    // MARK -- Actions and Buttons
    @objc func startNewSearch() {
        dismissCelebrationDown()
        self.performSegue(withIdentifier: "NewSearch", sender: nil)
    }
    
    
    @objc func dismissCelebrationDown() {
        print("==== Dismiss === ")
        
        let window = UIApplication.shared.keyWindow!
        if let celebrationView = window.viewWithTag(6) {
            // Fade Animate Out
            UIWindow.animate(withDuration: 1.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveLinear], animations: {
                // celebrationView.alpha = 0
                celebrationView.transform = CGAffineTransform(translationX: 0, y: (window.frame.height) * 1.1)
            }) { _ in
                celebrationView.removeFromSuperview()
            }
        }
    }
    
    @objc func shareButtonDidTap() {
        let activityVC = UIActivityViewController(activityItems: [puppyDetailImageView.image!, "Take a look at \(puppy.puppyName)♥︎!"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
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
            self.present(loginAlert, animated: true, completion: nil)
        }
        
        if favoritePuppies.contains(puppy) {
            // find the index location
            let index = favoritePuppies.index(of: puppy)
            favoritePuppies.remove(at: index!)
            puppyLikeButton.setImage(UIImage(named: "like-empty"), for: .normal)
        } else {
            favoritePuppies.insert(puppy, at: 0)
            puppyLikeButton.setImage(UIImage(named: "Like-solid"), for: .normal)
        }
    }
    
    @IBAction func topAdoptButtonDidTap(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func bottomAdoptButtonDidTap(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    @IBAction func callButtonDidTap(_ sender: Any) {
        // Validate phone and remove non-digits
        if shelterPhone.count > 10 {
            let phoneArray = shelterPhone.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            shelterPhone = phoneArray.joined(separator: "")
        }
        // Is valid phone.
        // All 10 characters should be confirmed digits from above
        if shelterPhone.count == 10 {
            // Is Valid Phone Number
            let url = NSURL(string: "tel://\(shelterPhone)")
            UIApplication.shared.open(url! as URL, completionHandler: nil)
        } else {
            // ALERT
            let callErrorAlert = UIAlertController(title: "Cannot call \(self.shelterName)", message: "No phone number is on file for this shelter.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            callErrorAlert.addAction(defaultAction)
            present(callErrorAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: -- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededSegue" {
            let caroselPageView = segue.destination as! ImageCaroselPageViewController
            caroselPageView.puppy = puppy
            
            caroselPageView.pageViewControllerDelegate = self
        }
    }
    
    // MARKt -- Get Shelter Name
    func getData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let shelterJSON : JSON = JSON(response.result.value!)
                
                func updateShelterData(json: JSON) {
                // MARK: -- Save Shelter Contact Data
                    self.shelterName = json["petfinder"]["shelter"]["name"]["$t"].stringValue.capitalized
                    
                    let shelterAddress = json["petfinder"]["shelter"]["address1"]["$t"].stringValue.capitalized
                    let shelterCity = self.puppy.puppyCity
                    let shelterState = self.puppy.puppyState
                    self.shelterPhone = json["petfinder"]["shelter"]["phone"]["$t"].stringValue
                //    let shelterEmail = json["petfinder"]["shelter"]["email"]["$t"].stringValue
                    self.shelterLong = json["petfinder"]["shelter"]["longitude"]["$t"].doubleValue
                    self.shelterLat = json["petfinder"]["shelter"]["latitude"]["$t"].doubleValue
                    
                    // Complete Shelter Variables
                    print("SHELTER NAME == \(self.shelterName)")
                    print("SHELTER LAT LONG == \(self.shelterLat), \(self.shelterLong)")
                    print("PHONE ========= \(self.shelterPhone) == \(self.shelterPhone.count)")
                    self.shelterCityStateLabel.text = "\(shelterCity), \(shelterState)"
                    
                    // Disable call button if no phone number
                    if self.shelterPhone.count < 10 {
                        self.callButton.backgroundColor = UIColor.groupTableViewBackground
                    }
                    
                    if self.shelterName.count > 0 {
                        self.shelterNameLabel.text = self.shelterName
                    } else {
                        self.shelterNameLabel.text = "Shelter Name Unknown"
                    }
                    
                    if shelterAddress.count > 0 {
                        self.shelterAddressLabel.text = shelterAddress
                    } else {
                        self.shelterAddressLabel.text = "Exact Shelter Address Unknown"
                    }
                }
                updateShelterData(json: shelterJSON)
                print("Success, got Shelter data!")
                print(self.puppy.puppyShelterID)
            }
            else { print(response.result.error as! String) }
        }
    }
    
    // MARK -- MAP Delegate functions
    
//
    
}


// MARK -- UIMessage/email Composer Delegate

extension PuppyDetailViewController {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([puppy.puppyContactEmail])
        mailComposerVC.setSubject("♥︎\(puppy.puppyName)♥︎ Please tell me more!")
        mailComposerVC.setMessageBody("Hello,\n\nI came across \(puppy.puppyName), (ID#\(puppy.puppyID)) on Resque and fell in love. Can we please set up a time to meet? My availability is as follows:\n\n", isHTML: false)
        
        // Mail Composer Cosmetics
//        let backgroundColor = UIColor(red: 0.3176, green: 0.6549, blue: 0.9765, alpha: 1.0)
//        mailComposerVC.navigationBar.isTranslucent = false
//        mailComposerVC.navigationBar.barTintColor = backgroundColor
//        mailComposerVC.navigationBar.tintColor = backgroundColor // Cancel button ~ any UITabBarButton items
//        mailComposerVC.navigationBar.titleTextAttributes = [
//            NSAttributedStringKey.foregroundColor : backgroundColor
//        ] // Title color
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Email is not configured on your device.  Please make sure your e-mail address is configured in the account settings and try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func yayAdoptionEmailSent() {
        print("===== YAY ====")
        // Present Celebration Controller to window
        let window = UIApplication.shared.keyWindow!
        let xPercentage = window.frame.width / 100.0
        let yPercentage = window.frame.height / 100.0
        
        let celebrateView:CelebrationView = CelebrationView(frame: CGRect(x: xPercentage * 0.0, y: yPercentage * 0.0, width: xPercentage * 100.0, height: yPercentage * 100.0))
        
        // Contruct Subview
        celebrateView.primaryActionButton.setTitle("Search Again", for: .normal)
        celebrateView.primaryActionButton.addTarget(self, action: #selector(startNewSearch), for: .touchUpInside)
        celebrateView.secondaryActionButton.setTitle("No Thanks", for: .normal)
        celebrateView.secondaryActionButton.addTarget(self, action: #selector(dismissCelebrationDown), for: .touchUpInside)
        celebrateView.closeButton.addTarget(self, action: #selector(dismissCelebrationDown), for: .touchUpInside)
        celebrateView.tag = 6
        
        window.addSubview(celebrateView)
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {() -> Void in
            if error == nil && result == .sent || result == .saved {
                self.yayAdoptionEmailSent()
            } else if error != nil {
                print(error!.localizedDescription)
            }
        })
    }
}

extension PuppyDetailViewController : ImageCaroselControllerDelegate {
    func setUpPageController(numberOfPages: Int) {
        pageControll.numberOfPages = numberOfPages
    }
    
    func turnPageController(to index: Int) {
        pageControll.currentPage = index
    }
}
