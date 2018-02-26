//
//  EditBreedTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 1/6/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

var selectedBreedTotal = 0

var breedsArray = [SearchBreeds]()
var selectedBreedsArray = [SearchBreeds]()

class EditBreedTableViewController: UITableViewController {

    var allBreedsSelected: Bool?
    
    
    @IBOutlet weak var toggleBreedsControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        breedsArray = [
            SearchBreeds(sectionName: "A", sectionBreeds:
                ["Affenpinscher",
                 "Afghan Hound",
                 "Airedale Terrier",
                 "Akbash",
                 "Akita",
                 "Alaskan Malamute",
                 "American Bulldog",
                 "American Eskimo Dog",
                 "American Hairless Terrier",
                 "American Staffordshire Terrier",
                 "American Water Spaniel",
                 "Anatolian Shepherd",
                 "Appenzell Mountain Dog",
                 "Australian Cattle Dog/Blue Heeler",
                 "Australian Kelpie",
                 "Australian Shepherd",
                 "Australian Terrier"]),
            SearchBreeds(sectionName: "B", sectionBreeds:
                ["Basenji",
                 "Basset Hound",
                 "Beagle",
                 "Bearded Collie",
                 "Beauceron",
                 "Bedlington Terrier",
                 "Belgian Shepherd Dog Sheepdog",
                 "Belgian Shepherd Laekenois",
                 "Belgian Shepherd Malinois",
                 "Belgian Shepherd Tervuren",
                 "Bernese Mountain Dog",
                 "Bichon Frise",
                 "Black and Tan Coonhound",
                 "Black Labrador Retriever",
                 "Black Mouth Cur",
                 "Black Russian Terrier",
                 "Bloodhound",
                 "Blue Lacy",
                 "Bluetick Coonhound",
                 "Boerboel",
                 "Bolognese",
                 "Border Collie",
                 "Border Terrier",
                 "Borzoi",
                 "Boston Terrier",
                 "Bouvier des Flanders",
                 "Boxer",
                 "Boykin Spaniel",
                 "Briard",
                 "Brittany Spaniel",
                 "Brussels Griffon",
                 "Bull Terrier",
                 "Bullmastiff"]),
            SearchBreeds(sectionName: "C", sectionBreeds:
                [ "Cairn Terrier",
                  "Canaan Dog",
                  "Cane Corso Mastiff",
                  "Carolina Dog",
                  "Catahoula Leopard Dog",
                  "Cattle Dog",
                  "Caucasian Sheepdog (Caucasian Ovtcharka)",
                  "Cavalier King Charles Spaniel",
                  "Chesapeake Bay Retriever",
                  "Chihuahua",
                  "Chinese Crested Dog",
                  "Chinese Foo Dog",
                  "Chinook",
                  "Chocolate Labrador Retriever",
                  "Chow Chow",
                  "Cirneco dell'Etna",
                  "Clumber Spaniel",
                  "Cockapoo",
                  "Cocker Spaniel",
                  "Collie",
                  "Coonhound",
                  "Corgi",
                  "Coton de Tulear",
                  "Curly-Coated Retriever"]),
            SearchBreeds(sectionName: "D", sectionBreeds:
                ["Dachshund",
                 "Dalmatian",
                 "Dandi Dinmont Terrier",
                 "Doberman Pinscher",
                 "Dogo Argentino",
                 "Dogue de Bordeaux",
                 "Dutch Shepherd"]),
            SearchBreeds(sectionName: "E", sectionBreeds:
                ["English Bulldog",
                 "English Cocker Spaniel",
                 "English Coonhound",
                 "English Pointer",
                 "English Setter",
                 "English Shepherd",
                 "English Springer Spaniel",
                 "English Toy Spaniel",
                 "Entlebucher",
                 "Eskimo Dog"]),
            SearchBreeds(sectionName: "F", sectionBreeds:
                ["Feist",
                 "Field Spaniel",
                 "Fila Brasileiro",
                 "Finnish Lapphund",
                 "Finnish Spitz",
                 "Flat-coated Retriever",
                 "Fox Terrier",
                 "Foxhound",
                 "French Bulldog"]),
            SearchBreeds(sectionName: "G", sectionBreeds:
                ["Galgo Spanish Greyhound",
                 "German Pinscher",
                 "German Shepherd Dog",
                 "German Shorthaired Pointer",
                 "German Spitz",
                 "German Wirehaired Pointer",
                 "Giant Schnauzer",
                 "Glen of Imaal Terrier",
                 "Golden Retriever",
                 "Gordon Setter",
                 "Great Dane",
                 "Great Pyrenees",
                 "Greater Swiss Mountain Dog",
                 "Greyhound"]),
            SearchBreeds(sectionName: "H", sectionBreeds:
                ["Harrier",
                 "Havanese",
                 "Hound",
                 "Hovawart",
                 "Husky"]),
            SearchBreeds(sectionName: "I", sectionBreeds:
                ["Ibizan Hound",
                 "Illyrian Sheepdog",
                 "Irish Setter",
                 "Irish Terrier",
                 "Irish Water Spaniel",
                 "Irish Wolfhound",
                 "Italian Greyhound",
                 "Italian Spinone"]),
            SearchBreeds(sectionName: "J", sectionBreeds:
                ["Jack Russell Terrier",
                 "Jack Russell Terrier (Parson Russell Terrier)",
                 "Japanese Chin",
                 "Jindo"]),
            SearchBreeds(sectionName: "K", sectionBreeds:
                ["Kai Dog",
                 "Karelian Bear Dog",
                 "Keeshond",
                 "Kerry Blue Terrier",
                 "Kishu",
                 "Klee Kai",
                 "Komondor",
                 "Kuvasz",
                 "Kyi Leo"]),
            SearchBreeds(sectionName: "L", sectionBreeds:
                ["Labrador Retriever",
                 "Lakeland Terrier",
                 "Lancashire Heeler",
                 "Leonberger",
                 "Lhasa Apso",
                 "Lowchen"]),
            SearchBreeds(sectionName: "M", sectionBreeds:
                ["Maltese",
                 "Manchester Terrier",
                 "Maremma Sheepdog",
                 "Mastiff",
                 "McNab",
                 "Miniature Pinscher",
                 "Mountain Cur",
                 "Mountain Dog",
                 "Munsterlander"]),
            SearchBreeds(sectionName: "N", sectionBreeds:
                ["Neapolitan Mastiff",
                 "New Guinea Singing Dog",
                 "Newfoundland Dog",
                 "Norfolk Terrier",
                 "Norwegian Buhund",
                 "Norwegian Elkhound",
                 "Norwegian Lundehund",
                 "Norwich Terrier",
                 "Nova Scotia Duck-Tolling Retriever"]),
            SearchBreeds(sectionName: "O", sectionBreeds:
                ["Old English Sheepdog",
                 "Otterhound"]),
            SearchBreeds(sectionName: "P", sectionBreeds:
                ["Papillon",
                 "Patterdale Terrier (Fell Terrier)",
                 "Pekingese",
                 "Peruvian Inca Orchid",
                 "Petit Basset Griffon Vendeen",
                 "Pharaoh Hound",
                 "Pit Bull Terrier",
                 "Plott Hound",
                 "Podengo Portugueso",
                 "Pointer",
                 "Polish Lowland Sheepdog",
                 "Pomeranian",
                 "Poodle",
                 "Portuguese Water Dog",
                 "Presa Canario",
                 "Pug",
                 "Puli",
                 "Pumi"]),
            SearchBreeds(sectionName: "R", sectionBreeds:
                ["Rat Terrier",
                 "Redbone Coonhound",
                 "Retriever",
                 "Rhodesian Ridgeback",
                 "Rottweiler"]),
            SearchBreeds(sectionName: "S", sectionBreeds:
                ["Saint Bernard St. Bernard",
                 "Saluki",
                 "Samoyed",
                 "Sarplaninac",
                 "Schipperke",
                 "Schnauzer",
                 "Scottish Deerhound",
                 "Scottish Terrier Scottie",
                 "Sealyham Terrier",
                 "Setter",
                 "Shar Pei",
                 "Sheep Dog",
                 "Shepherd",
                 "Shetland Sheepdog Sheltie",
                 "Shiba Inu",
                 "Shih Tzu",
                 "Siberian Husky",
                 "Silky Terrier",
                 "Skye Terrier",
                 "Sloughi",
                 "Smooth Fox Terrier",
                 "South Russian Ovtcharka",
                 "Spaniel",
                 "Spitz",
                 "Staffordshire Bull Terrier",
                 "Standard Poodle",
                 "Sussex Spaniel",
                 "Swedish Vallhund"]),
            SearchBreeds(sectionName: "T", sectionBreeds:
                ["Terrier",
                 "Thai Ridgeback",
                 "Tibetan Mastiff",
                 "Tibetan Spaniel",
                 "Tibetan Terrier",
                 "Tosa Inu",
                 "Toy Fox Terrier",
                 "Treeing Walker Coonhound"]),
            SearchBreeds(sectionName: "V", sectionBreeds:
                ["Vizsla"]),
            SearchBreeds(sectionName: "W", sectionBreeds:
                ["Weimaraner",
                 "Welsh Corgi",
                 "Welsh Springer Spaniel",
                 "Welsh Terrier",
                 "West Highland White Terrier Westie",
                 "Wheaten Terrier",
                 "Whippet",
                 "White German Shepherd",
                 "Wire Fox Terrier",
                 "Wire-haired Pointing Griffon",
                 "Wirehaired Terrier"]),
            SearchBreeds(sectionName: "X", sectionBreeds:
                ["Xoloitzcuintle/Mexican Hairless"]),
            SearchBreeds(sectionName: "Y", sectionBreeds:
                ["Yellow Labrador Retriever",
                 "Yorkshire Terrier Yorkie"])
        ]
        
        // SETUP selectedBreedsArray to display appropriately against the breedsArray refference
        if selectedBreedTotal == 0 || allBreedsSelected == true {
            selectedBreedsArray = breedsArray
        }
    }
    
    // HELPERS
    
    func tallySelectedBreeds() {
        selectedBreedTotal = 0
        for i in 0..<selectedBreedsArray.count {
            selectedBreedTotal += selectedBreedsArray[i].sectionBreeds.count
        }
        print(selectedBreedTotal)
    }
    
    @IBAction func toggleBreedsDidTap(_ sender: Any) {
        switch toggleBreedsControl.selectedSegmentIndex {
        case 0:
            selectedBreedsArray = breedsArray
            allBreedsSelected = true
            ;
        case 1:
           // Reset the array but maintain the sections
            for i in 0..<selectedBreedsArray.count {
                selectedBreedsArray[i].sectionBreeds = []
            }
            allBreedsSelected = false
            ;
        default: break
        }
        tableView.reloadData()
        print(selectedBreedsArray)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tallySelectedBreeds()
    }
}

    // MARK: - Table view data source
extension EditBreedTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return breedsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedsArray[section].sectionBreeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as! BreedTableViewCell
    // Configure the cell...
        
        if allBreedsSelected == false {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }

        // SETUP for Previous Selection
        if allBreedsSelected == true {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else if selectedBreedsArray[indexPath.section].sectionBreeds.contains(breedsArray[indexPath.section].sectionBreeds[indexPath.row]) {
            // checkmark that shit
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            // Don't checkmark that shit
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        
    cell.breedNameLabel.text = breedsArray[indexPath.section].sectionBreeds[indexPath.row]
    return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            // Take it out of the array and update it --- same method to add back in as well
            selectedBreedsArray[indexPath.section].sectionBreeds = selectedBreedsArray[indexPath.section].sectionBreeds.filter { $0 != breedsArray[indexPath.section].sectionBreeds[indexPath.row] }
            
            print(selectedBreedsArray)
            
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            // Put it back in the array in alphabetical order
            // Works, but places at the end of the section array?
            selectedBreedsArray[indexPath.section].sectionBreeds.append(breedsArray[indexPath.section].sectionBreeds[indexPath.row])
            
            print(selectedBreedsArray)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return breedsArray[section].sectionName
    }
    
}

