//
//  ViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 12/12/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD
import CoreML
import Vision
import Firebase

// Petfinder API Endpoint and Paramater Variables
var petFinderPath = "http://api.petfinder.com/pet.find?"
var petFinderShelterPath = "http://api.petfinder.com/shelter.get?"
var petFinderSecret = "5be4d8778cb7c34684375711adc7b2aa"
var jsonp = "callback=?"
var faveIndex : Int = 0
var pupTapIndex : Int = 0
var photoSearchOffset : Int = 0

var geocoder = CLGeocoder()

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // Delagate Setup
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var pizzaScrollView: UIScrollView!
    @IBOutlet weak var hamburgerButtonItem: UIBarButtonItem!
    
    //Image search variables
    var imagePickerHelper: ImagePickerHelper!
    var selectedSearchImage: CIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if filteredPuppyDict.count != 0 {
            
            for i in 0..<filteredPuppyDict.count {
                // Hide like button if pup is already in faves
                // add the buttons
                let xPosition = self.view.frame.width * CGFloat(i + photoSearchOffset)
                let widthPercentage = self.view.frame.width/100
                let heightPercentage = self.view.frame.height/100
                
                let buttonSubview:ButtonViewFrame = ButtonViewFrame(frame: CGRect(x: xPosition, y: heightPercentage * 68, width: widthPercentage * 100, height: heightPercentage * 14))
                
                // make Like buttons tie to current pup.
                buttonSubview.xibLike.tag = i
                
                // Hide like button if pup is already in faves
                if favoritePuppies.contains(filteredPuppyDict[i]) {
                    buttonSubview.xibLike.isHidden = true
                }
                
                pizzaScrollView.addSubview(buttonSubview)
            }
            // Test image and button accuracy on return to view
            if isImageSearchActive == true {
                photoSearchOffset = 1
            }
            isImageSearchActive = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isImageSearchActive == true {
            let scrollReset = CGPoint(x: 0, y: 0)
            pizzaScrollView.contentOffset = scrollReset
        }
        
        if isImageSearchActive == false {
            photoSearchOffset = 0
        }
        
        if breed != "" && dogBreedList.contains(breed) {
            let breedCheck = dogBreedList.index(of: breed)
            let breedConfirm = dogBreedList[breedCheck!]
            print("contains Breed == \(breedConfirm)")
            breed = breedConfirm
            breedName = breedConfirm
        } else {
            breed = ""
        }
        
        // Setup Hamburgr Menu
        hamburgerButtonItem.target = self.revealViewController()
        hamburgerButtonItem.action = #selector(SWRevealViewController().revealToggle(_:))
//      view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())  ---  BROKEN WITH SEARCH SEGUE?
        
        // Setup Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        // Setup SVProgressHUD Styles
        SVProgressHUD.setCornerRadius(6.0)
        SVProgressHUD.setContainerView(view)
        SVProgressHUD.setFont(UIFont(name: "Avenir", size: 14)!)
        
        SVProgressHUD.show(withStatus: "Fetching")
        locationManager.startUpdatingLocation()
    }
    
    // Location code
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
            
            //ReverseGeolocate
            geocoder.reverseGeocodeLocation(location, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode failed: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        // Manual Zipcode Override. Only runs if no location entered
                        if manualZipCode == false {
                            zipCode = String(pm.postalCode!)
                            print(zipCode)
                        }
                        
                        let params : [String : String] = ["key" : petFinderSecret, "location" : zipCode, "format" : format, "count" : String(count), "output" : output, "animal" : animal, "breed" : breedName, "offset" : String(offset), "age" : age, "size" : breedSize, "sex" : searchSex, "jsonp" : jsonp]
                        
                        self.getData(url: petFinderPath, parameters: params)
                    }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    // End Location Code
    
    
    func getData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let puppyJSON : JSON = JSON(response.result.value!)
                
                func updatePuppyData(json: JSON) {
                    
                    for i in 0..<json["petfinder"]["pets"]["pet"].count {
                        
                        func appendPuppy(i: Int) {
                            
                            //if breeds array contains more than one value then the pup is a mix.
                            if json["petfinder"]["pets"]["pet"][i]["breeds"]["breed"].count > 1 {
                                puppyBreed = json["petfinder"]["pets"]["pet"][i]["breeds"]["breed"][0]["$t"].stringValue + " mix"
                            }
                            else {
                                puppyBreed = json["petfinder"]["pets"]["pet"][i]["breeds"]["breed"]["$t"].stringValue
                            }
                            
                            // Loop through all Images to add the largest to the additional images array
                            var additionalImages = [String]()
                            
                            for p in 0..<json["petfinder"]["pets"]["pet"][i]["media"]["photos"]["photo"].count {
                                if json["petfinder"]["pets"]["pet"][i]["media"]["photos"]["photo"][p]["@size"].stringValue == "x" {
                                    additionalImages.append(json["petfinder"]["pets"]["pet"][i]["media"]["photos"]["photo"][p]["$t"].stringValue)
                                }
                            }
                            
                            // Loop through all Images to add the largest to the additional images array
                            var allOptions = [String]()
                            
                            for o in 0..<json["petfinder"]["pets"]["pet"][i]["options"]["option"].count {
                                allOptions.append(json["petfinder"]["pets"]["pet"][i]["options"]["option"][o]["$t"].stringValue)
                            }
                            
                            let newPet = Puppy(
                                puppyID: json["petfinder"]["pets"]["pet"][i]["id"]["$t"].intValue,
                                puppyName: json["petfinder"]["pets"]["pet"][i]["name"]["$t"].stringValue,
                                puppyAge: json["petfinder"]["pets"]["pet"][i]["age"]["$t"].stringValue,
                                puppyBreed: puppyBreed,
                                puppyCity: json["petfinder"]["pets"]["pet"][i]["contact"]["city"]["$t"].stringValue,
                                puppyState: json["petfinder"]["pets"]["pet"][i]["contact"]["state"]["$t"].stringValue,
                                puppyImage: json["petfinder"]["pets"]["pet"][i]["media"]["photos"]["photo"][2]["$t"].stringValue,
                                puppySize: json["petfinder"]["pets"]["pet"][i]["size"]["$t"].stringValue,
                                puppySex: json["petfinder"]["pets"]["pet"][i]["sex"]["$t"].stringValue,
                                puppyBio: json["petfinder"]["pets"]["pet"][i]["description"]["$t"].stringValue,
                                puppyShelterID: json["petfinder"]["pets"]["pet"][i]["shelterId"]["$t"].stringValue,
                                puppyDescription: json["petfinder"]["pets"]["pet"][i]["description"]["$t"].stringValue,
                                puppyContactEmail: json["petfinder"]["pets"]["pet"][i]["contact"]["email"]["$t"].stringValue,
                                
                                puppyAdditionalImages: additionalImages,
                                isFave: false,
                                puppyAllOptions: allOptions
                                )
                            
                            puppyDict.append(newPet)
                        }
                        appendPuppy(i: i)
                    }
                }
                // MARK: -- END OF LOOP
                
                updatePuppyData(json: puppyJSON)
                print("Success, got data!")
                self.loadPuppies()
            }
            else {
                print(response.result.error as Any)
            }
        }
    }
    
    func loadPuppies() {
        
        // filters
        filterPuppies()
        SVProgressHUD.dismiss()
        
        if filteredPuppyDict != [] {
            if isImageSearchActive == true {
                photoSearchOffset = 1
                
                //   ===== test =======
                
                            let xPercentage = view.frame.width / 100.0
                            let yPercentage = view.frame.height / 100.0
                
                            if notADogDescription != "" {
                                let notADogSubview : ThatsNotADogView = ThatsNotADogView(frame: CGRect(x: xPercentage * 7.5, y: yPercentage * 6, width: xPercentage * 85, height: yPercentage * 60))
                                
                                // GET PREFIX - either "a" or "an"
                                var prefix = "a"
                                if notADogDescription.first == "A" || notADogDescription.first == "E" || notADogDescription.first == "I" || notADogDescription.first == "O" || notADogDescription.first == "U" {
                                    prefix = "an"
                                }
                                
                                // CONSTRUCT NOT A DOG VIEW
                                notADogSubview.cardCopy.text = "Because we’re not sure what breed it is. In fact we’re \(breedConfidencePercentage)% sure it's \(prefix) \(notADogDescription). Sorry—here’s some cute dogs available for adoption nearby though."
                                
                                pizzaScrollView.addSubview(notADogSubview)
                                
                            } else {
                                // IS A DOG
                
                            let photoResultsubview:PhotoMatchViewFrame = PhotoMatchViewFrame(frame: CGRect(x: xPercentage * 7.5, y: yPercentage * 6, width: xPercentage * 85, height: yPercentage * 60))
                
                            // Construct
                
                            photoResultsubview.resultImageView.sd_setImage(with: URL(string: breedHeroImage), completed: nil)
                
                            photoResultsubview.breedResultLabel.text = breedName
                            photoResultsubview.breedResultLabel.setLineHeight(lineHeight: 0.1)
                
                            // Add breed trait tags
                            for i in 0..<breedTraits.count{
                                let trait = photoResultsubview.traitContainer.viewWithTag(i+1) as? UILabel
                                trait?.text = " \(breedTraits[i])    ".capitalized
                                if trait?.text?.capitalized == " Hypoallergenic    " {
                                    trait?.backgroundColor = UIColor(red: 0.3176, green: 0.6549, blue: 0.9765, alpha: 0.85) // Blue color
                                    trait?.textColor = UIColor.white
                                } else {
                                    trait?.backgroundColor = UIColor.groupTableViewBackground
                                    trait?.textColor = UIColor.gray
                                }
                                trait?.layer.cornerRadius = (trait?.frame.height)! / 2.0
                                trait?.clipsToBounds = true
                                trait?.layer.borderWidth = 0.5
                                trait?.layer.borderColor = UIColor.gray.cgColor
                            }
                
                            if breedConfidencePercentage >= 75 {
                                photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% VERY CONFIDENT"
                                photoResultsubview.confidenceCategoryLabel.textColor = UIColor(red: 0.4588, green: 0.749, blue: 0, alpha: 1.0) /* #75bf00 GREEN */
                            } else if breedConfidencePercentage >= 50 {
                                photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% FAIRLY CONFIDENT"
                            } else if breedConfidencePercentage >= 25 {
                                photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% SOMEWHAT CONFIDENT"
                                photoResultsubview.confidenceCategoryLabel.textColor = UIColor.orange
                            } else if breedConfidencePercentage >= 0 {
                                photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% NOT VERY CONFIDENT"
                                photoResultsubview.confidenceCategoryLabel.textColor = UIColor.red
                            }
                
                            // END
                
                            pizzaScrollView.addSubview(photoResultsubview)
                            }
                
                            // WAS x-6 & y-2 for top left corner placement
                            let selectedPhoto:SelectedPhotoView = SelectedPhotoView(frame: CGRect(x: xPercentage * 10, y: yPercentage * 22, width: xPercentage * 22, height: xPercentage * 22))
                
                            // Construct
                            if searchPhoto != nil {
                                selectedPhoto.selectedPhoto.image = searchPhoto
                            }
                
                            let nearbySubview:NearbyButtonView = NearbyButtonView(frame: CGRect(x: xPercentage, y: yPercentage * 68, width: xPercentage * 100, height: yPercentage * 14))
                            nearbySubview.nearbyCountButton.setTitle(String(filteredPuppyDict.count), for: .normal)
                
                            pizzaScrollView.addSubview(nearbySubview)
                            pizzaScrollView.addSubview(selectedPhoto)
                
                // ======== end ========
            }
        for i in 0..<filteredPuppyDict.count {
            ///
            let xPosition = self.view.frame.width * CGFloat(i + photoSearchOffset)
            let widthPercentage = self.view.frame.width/100
            let heightPercentage = self.view.frame.height/100
            let petSubview:RoundedViewFrame = RoundedViewFrame(frame: CGRect(x:xPosition + (widthPercentage * 7.5), y: heightPercentage * 6, width: widthPercentage * 85, height: heightPercentage * 60))
            petSubview.xibName.text = filteredPuppyDict[i].puppyName
            
            // Make sure there is a valid image. Use placeholder if not
            if !filteredPuppyDict[i].puppyImage.isEmpty {
                petSubview.xibImage.sd_setImage(with: URL(string: filteredPuppyDict[i].puppyImage))
            }
            else {
                petSubview.xibImage.image = UIImage(named: "pizza-placeholder")
            }
            petSubview.xibImage.tag = i
            petSubview.tag = i
            
            // Gesture Recognizer
            petSubview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailSegue(sender:))))
            
            petSubview.xibAge.text = filteredPuppyDict[i].puppyAge
            petSubview.xibBreed.text = filteredPuppyDict[i].puppyBreed
            petSubview.xibCity.text = "in " + filteredPuppyDict[i].puppyCity + ", "
            petSubview.xibState.text = filteredPuppyDict[i].puppyState
            
            pizzaScrollView.addSubview(petSubview)
            pizzaScrollView.contentSize.width = pizzaScrollView.frame.width * CGFloat(i + 1 + photoSearchOffset)
            
            // add the buttons
            let buttonSubview:ButtonViewFrame = ButtonViewFrame(frame: CGRect(x: xPosition, y: heightPercentage * 68, width: widthPercentage * 100, height: heightPercentage * 14))
            
            // make Like buttons tie to current pup.
            buttonSubview.xibLike.tag = i
            
            // Hide like button if pup is already in faves
            if favoritePuppies.contains(filteredPuppyDict[i]) {
                buttonSubview.xibLike.isHidden = true
            }
            
            pizzaScrollView.addSubview(buttonSubview)
            //
          }
        }
        // UPDATE Offset count for next search
    //  offset = offset + count
        print(offset)
        
        
        // Message Card View
        // TODO: Create Subview for the Empty State
        
        if filteredPuppyDict.count == count {

            // Position Subview
            let xPercentage = view.frame.width / 100.0
            let yPercentage = view.frame.height / 100.0
            pizzaScrollView.contentSize.width = (pizzaScrollView.contentSize.width / CGFloat(count)) * (CGFloat(count) + 1)
            
            let subview:MessageCard = MessageCard(frame: CGRect(x: (pizzaScrollView.contentSize.width / CGFloat(count + 1) * CGFloat(count)) + (7.5 * xPercentage), y: yPercentage * 6.0, width: xPercentage * 85.0, height: yPercentage * 60.0))
            
            // Contruct Subview
            subview.heroImage.image = UIImage(named: "no-faves-4")
            subview.titleLabel.text = "But wait, there's more"
            subview.descriptionLabel.text = "click below to keep browsing."
            subview.actionbutton.setTitle("Keep Browsing", for: .normal)
            subview.actionbutton.addTarget(self, action: #selector(self.loadMorePuppies), for: .touchUpInside)
            
            pizzaScrollView.addSubview(subview)
        // Show Broadening card if only 5 or less appear
        } else if filteredPuppyDict.count < 6 && filteredPuppyDict.count > 0 {
            
            // Position Subview
            let xPercentage = view.frame.width / 100.0
            let yPercentage = view.frame.height / 100.0
            pizzaScrollView.contentSize.width = (pizzaScrollView.contentSize.width / CGFloat(filteredPuppyDict.count)) * (CGFloat(filteredPuppyDict.count) + 1)
            
            // Complex xPosition
            let xPosition = (pizzaScrollView.contentSize.width / CGFloat(filteredPuppyDict.count + 1) * CGFloat(filteredPuppyDict.count)) + (7.5 * xPercentage)
            
            let subview:MessageCard = MessageCard(frame: CGRect(x: xPosition, y: yPercentage * 6.0, width: xPercentage * 85.0, height: yPercentage * 60.0))
            
            // Contruct Subview
            // TODO: Change this image to the new image once it's made
            subview.heroImage.image = UIImage(named: "no-faves-4")
            subview.titleLabel.text = "Bummer, that's all"
            subview.descriptionLabel.text = "Click below to broaden your search."
            subview.actionbutton.setTitle("Broaden Search", for: .normal)
            subview.actionbutton.addTarget(self, action: #selector(self.startNewSearch), for: .touchUpInside)
            
            pizzaScrollView.addSubview(subview)
        } else if filteredPuppyDict.count == 0 {
            // Show if no search results
            // Position Subview
            let xPercentage = view.frame.width / 100.0
            let yPercentage = view.frame.height / 100.0
            
            pizzaScrollView.contentSize.width = view.frame.width
            
            if isImageSearchActive == true {
                // IS A DOG
                
                let photoResultsubview:PhotoMatchViewFrame = PhotoMatchViewFrame(frame: CGRect(x: xPercentage * 7.5, y: yPercentage * 6, width: xPercentage * 85, height: yPercentage * 60))
                
                // Construct
                
                photoResultsubview.resultImageView.sd_setImage(with: URL(string: breedHeroImage), completed: nil)
                
                photoResultsubview.breedResultLabel.text = breedName
                photoResultsubview.breedResultLabel.setLineHeight(lineHeight: 0.1)
                
                // Add breed trait tags
                for i in 0..<breedTraits.count{
                    let trait = photoResultsubview.traitContainer.viewWithTag(i+1) as? UILabel
                    trait?.text = " \(breedTraits[i])    ".capitalized
                    if trait?.text?.capitalized == " Hypoallergenic    " {
                        trait?.backgroundColor = UIColor(red: 0.3176, green: 0.6549, blue: 0.9765, alpha: 0.85) // Blue color
                        trait?.textColor = UIColor.white
                    } else {
                        trait?.backgroundColor = UIColor.groupTableViewBackground
                        trait?.textColor = UIColor.gray
                    }
                    trait?.layer.cornerRadius = (trait?.frame.height)! / 2.0
                    trait?.clipsToBounds = true
                    trait?.layer.borderWidth = 0.5
                    trait?.layer.borderColor = UIColor.gray.cgColor
                }
                
                if breedConfidencePercentage >= 75 {
                    photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% VERY CONFIDENT"
                    photoResultsubview.confidenceCategoryLabel.textColor = UIColor(red: 0.4588, green: 0.749, blue: 0, alpha: 1.0) /* #75bf00 GREEN */
                } else if breedConfidencePercentage >= 50 {
                    photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% FAIRLY CONFIDENT"
                } else if breedConfidencePercentage >= 25 {
                    photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% SOMEWHAT CONFIDENT"
                    photoResultsubview.confidenceCategoryLabel.textColor = UIColor.orange
                } else if breedConfidencePercentage >= 0 {
                    photoResultsubview.confidenceCategoryLabel.text = "\(breedConfidencePercentage)% NOT VERY CONFIDENT"
                    photoResultsubview.confidenceCategoryLabel.textColor = UIColor.red
                }
                
                // END
                
                pizzaScrollView.contentSize.width = view.frame.width * 2.0
                pizzaScrollView.addSubview(photoResultsubview)
            
            // WAS x-6 & y-2 for top left corner placement
            let selectedPhoto:SelectedPhotoView = SelectedPhotoView(frame: CGRect(x: xPercentage * 10, y: yPercentage * 22, width: xPercentage * 22, height: xPercentage * 22))
            
            // Construct
            if searchPhoto != nil {
                selectedPhoto.selectedPhoto.image = searchPhoto
            }
            
            let nearbySubview:NearbyButtonView = NearbyButtonView(frame: CGRect(x: xPercentage, y: yPercentage * 68, width: xPercentage * 100, height: yPercentage * 14))
            nearbySubview.nearbyCountButton.setTitle(String(filteredPuppyDict.count), for: .normal)
            
            pizzaScrollView.addSubview(nearbySubview)
            pizzaScrollView.addSubview(selectedPhoto)
            }
    // Account for image offset?
            var resultOffset = 0
            if isImageSearchActive == true {
                resultOffset = 1
            }
            
            let xPosition = (view.frame.width * CGFloat(resultOffset)) + xPercentage * 7.5
            
            let subview:MessageCard = MessageCard(frame: CGRect(x: xPosition, y: yPercentage * 6.0, width: xPercentage * 85.0, height: yPercentage * 60.0))
            
            // Contruct NO Results Found Subview
            // TODO: Change this image to the new image once it's made
            subview.heroImage.image = UIImage(named: "no-faves-4")
            subview.titleLabel.text = "No results found"
            subview.descriptionLabel.text = "Click below to broaden your search."
            subview.actionbutton.setTitle("Broaden Search", for: .normal)
            subview.actionbutton.addTarget(self, action: #selector(self.startNewSearch), for: .touchUpInside)
            
            pizzaScrollView.addSubview(subview)
        }
        //
    }
    
    @objc func detailSegue(sender: UITapGestureRecognizer) {
        // Gets the x coordinate of where the touch took place
        pupTapIndex = Int(sender.location(in: pizzaScrollView).x)
        
        // Rounds down to the appropriate int to use as index value
        pupTapIndex = pupTapIndex / Int(view.frame.width)
        performSegue(withIdentifier: "DirectDetailSegue", sender: nil)
    }
    
    @objc func loadMorePuppies() {
        offset = offset + count
        // Means that "Keep Browsing" was tapped on an image search
        // The image result should be hidden
        if isImageSearchActive == true && offset > count {
            isImageSearchActive = false
        }
        print("Part 2 Offset = \(offset)")
        filteredPuppyDict = []
        puppyDict = []
        
        for view in pizzaScrollView.subviews {
           view.removeFromSuperview()
        }
        viewDidLoad()
    }
    
    class func pushAlert(alert: UIAlertController) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func startNewSearch() {
        self.performSegue(withIdentifier: "NewSearch", sender: nil)
    }
    
    // MARK: Add Actions
    
    @IBAction func imageSearchDidTap(_ sender: Any) {
        // Reset Not a Dog Variable
        notADogDescription = ""
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.selectedSearchImage = CIImage(image: image!)
            
            //CORML
            self.runImageDetection(image: self.selectedSearchImage)
            
            // Reset the viewController
            self.loadMorePuppies()
        })
    }
    
    func runImageDetection(image: CIImage) {
        if #available(iOS 11.0, *) {
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
                fatalError("Loading CoreML Failed.")
            }
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image")
                }
                // Results from Model
                // Crosscheck first result against breed list
                print(results)
                if let firstResult = results.first {
                    let breedCrossCheck = firstResult.identifier.capitalized
                    if dogBreedList.contains(breedCrossCheck) {
                        let breedIndex = dogBreedList.index(of: breedCrossCheck)
                        breed = breedCrossCheck
                     // breedName = breedCrossCheck
                        breedName = breedDict[breedIndex!].breedDisplayName
                        breedHeroImage = breedDict[breedIndex!].breedImage
                        breedDescription = breedDict[breedIndex!].breedDescription!
                        
                        // ADD logic to populate label tags
                        breedTraits = []
                        for trait in breedDict[breedIndex!].breedPersonality {
                            breedTraits.append(trait)
                        }
                        
                        offset = 0
                        isImageSearchActive = true
                        searchPhoto = UIImage(ciImage: image)
                        breedConfidencePercentage = Int(firstResult.confidence * 100)
                        
                        print("==== \(breed) ====")
                    } else {
                        if visionBreedList.contains(breedCrossCheck) {
                            let breedIndex = visionBreedList.index(of: breedCrossCheck)
                            breed = breedCrossCheck
                       //   breedName = dogBreedList[breedIndex!]
                            breedName = breedDict[breedIndex!].breedDisplayName
                            breedHeroImage = breedDict[breedIndex!].breedImage
                            breedDescription = breedDict[breedIndex!].breedDescription!
                            
                            // ADD logic to populate label tags
                            breedTraits = []
                            for trait in breedDict[breedIndex!].breedPersonality {
                                breedTraits.append(trait)
                            }
                            
                            isImageSearchActive = true
                            searchPhoto = UIImage(ciImage: image)
                            breedConfidencePercentage = Int(firstResult.confidence * 100)
                        } else {
                            print("==== \(breed) ====")
                            print("That's not a dog!")
                            notADogDescription = breedCrossCheck
                            
                            // Separate into String
                            let descriptionToParse = notADogDescription.components(separatedBy: ",")
                            notADogDescription = descriptionToParse[0]
                            print(notADogDescription)
                            
                            // Set Params for the image rec for the not a dog view
                            isImageSearchActive = true
                            searchPhoto = UIImage(ciImage: image)
                            breedConfidencePercentage = Int(firstResult.confidence * 100)
                            breed = ""
                            breedName = ""
                        }
                    }
                }
            })
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            }
            catch {
                print(error)
            }
            
        } else {
            // Fallback on earlier versions
            // TODO Error Handling
        }
    }
    
    
    func filterPuppies() {
        for x in 0..<puppyDict.count {
            // Controlls for only filtered puppies -- Size and Age
            if selectedSizeArray.contains(puppyDict[x].puppySize) && ageArray.contains(puppyDict[x].puppyAge) && selectedBreedTotal == 0 || selectedBreedTotal == 240 {
                filteredPuppyDict.append(puppyDict[x])
            } else if selectedSizeArray.contains(puppyDict[x].puppySize) && ageArray.contains(puppyDict[x].puppyAge) && selectedBreedTotal < 240 {
                for i in 0..<selectedBreedsArray.count {
                    // iterable to account for all sections with valid breeds
                    if selectedBreedsArray[i].sectionBreeds.contains(puppyDict[x].puppyBreed) {
                        filteredPuppyDict.append(puppyDict[x])
                    } else {
                        continue
                    }
                }
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DirectDetailSegue" {
            let puppyDetailVC = segue.destination as! PuppyDetailViewController
            let selectedPuppy = filteredPuppyDict[pupTapIndex - photoSearchOffset]
                puppyDetailVC.puppy = selectedPuppy
        }
    }
}

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
