//
//  SearchTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 12/29/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import CoreML
import Vision

class SearchTableViewController: UITableViewController {
 
    // MARK: -- Search Labels
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var breedsLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var hamburgerButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    @IBOutlet weak var searchControl: UISegmentedControl!
    
    var imagePickerHelper: ImagePickerHelper!
    var selectedSearchImage: UIImage!
    

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        // Set the search control to filter state
        searchControl.selectedSegmentIndex = 0
        
        // Update the labels to what's there
        zipcodeLabel.text = "Zipcode:  \(zipCode)"
        rangeLabel.text = "Range:  \(searchRadius) mi"
        
        // BREED
        // 50 should be updated to 240 once all sections are included
        if selectedBreedTotal == 240 {
            breed = ""
            breedsLabel.text = "Breeds:  All"
        } else if selectedBreedTotal == 239 {
            let breedsExcluded = 240 - selectedBreedTotal
            breed = ""
            breedsLabel.text = "Breeds:  \(breedsExcluded) Breed Excluded".capitalized
        }
        else if selectedBreedTotal < 239 && selectedBreedTotal > 1 {
            let breedsExcluded = 240 - selectedBreedTotal
            breed = ""
            breedsLabel.text = "Breeds:  \(breedsExcluded) Breeds Excluded".capitalized
        } else if selectedBreedTotal == 1 {
            // Identify the appropriate section where the single breed is contained
            for i in 0..<selectedBreedsArray.count {
                if selectedBreedsArray[i].sectionBreeds.count > 0 {
                    breed = selectedBreedsArray[i].sectionBreeds[0]
                } else {
                    continue
                }
            }
            breedsLabel.text = "Breeds:  \(breed)".capitalized
        }
        
        // SIZE
        if selectedSizeArray.count == 5 || selectedSizeArray.count == 1 {
            sizeLabel.text = "Sizes:  Any"
        } else {
            sizeLabel.text = "Sizes:  "
            for size in selectedSizeArray {
                sizeLabel.text! += "\(size),  "
            }
            // Remove last comma and two spaces
            let endIndex = sizeLabel.text!.index(sizeLabel.text!.endIndex, offsetBy: -6)
            sizeLabel.text! = sizeLabel.text!.substring(to: endIndex)
        }
        
        
        // GENDER
        if genderArray.count > 1 && genderArray.count < 3 {
            genderLabel.text = "Genders:  \(genderArray[0])"
        } else {
            genderLabel.text = "Genders:  Any"
        }
        
        
        // AGE
        if ageArray.count == 5 || ageArray.count == 1 {
            ageLabel.text = "Ages:  Any"
        } else {
            ageLabel.text = "Ages:  "
            for age in ageArray {
                ageLabel.text! += "\(age),  "
                }
//            if ageArray.contains("Baby") {
//                ageArray = ageArray.filter({ $0 != "Baby" })
//                ageArray.insert("Puppy", at: 0)
//            }
            // Remove last comma and two spaces
            let endIndex = ageLabel.text!.index(ageLabel.text!.endIndex, offsetBy: -7)
            ageLabel.text! = String(ageLabel.text![...endIndex])
        }
        
        
        // GENDER
        if genderArray.count > 1 && genderArray.count < 3 {
            genderLabel.text = "Genders:  \(genderArray[0])"
        } else {
            genderLabel.text = "Genders:  Any"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Hamburgr Menu
        hamburgerButtonItem.target = self.revealViewController()
        hamburgerButtonItem.action = #selector(SWRevealViewController().revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Cosmetics
    }
    
    func updateSearchParams() {
        // TODO: Save all of the new inputs
        print("=== Params Saved ====")
    }
    
    @IBAction func searchControlDidToggle(_ sender: Any) {
        if searchControl.selectedSegmentIndex == 1 {
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                self.selectedSearchImage = image
                // UPDATE TEST
                searchPhoto = image
                self.searchButtonDidTap((Any).self)
            })
        }
    }

    @IBAction func searchButtonDidTap(_ sender: Any) {
        if searchControl.selectedSegmentIndex == 0 {
            selectedSearchImage = nil
            searchPhoto = nil
            isImageSearchActive = false
            breed = ""
            breedName = ""
        }
        
        puppyDict = []
        filteredPuppyDict = []
        offset = 0
        updateSearchParams()
        performSegue(withIdentifier: "HomeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeSegue" && searchControl.selectedSegmentIndex == 1 {
            let destination = segue.destination as! HomeViewController
            destination.runImageDetection(image: CIImage(image: searchPhoto!)!)
        } else if segue.identifier == "HomeSegue" && searchControl.selectedSegmentIndex == 0 {
            let destination = segue.destination as! HomeViewController
            destination.viewDidLoad()
        }
    }
//
}
