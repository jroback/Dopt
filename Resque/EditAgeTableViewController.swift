//
//  EditAgeTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 1/2/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class EditAgeTableViewController: UITableViewController {

    let ageIndex = [0, 1, 2, 3]
    let ageStringIndex = ["Baby", "Young", "Adult", "Senior"]
    
    @IBOutlet weak var puppyCell: UITableViewCell!
    @IBOutlet weak var youngCell: UITableViewCell!
    @IBOutlet weak var adultCell: UITableViewCell!
    @IBOutlet weak var seniorCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SETUP AGE
        if ageArray.contains("Baby") {
            puppyCell.accessoryType = .checkmark
        } else {
            puppyCell.accessoryType = .none
        }
        
        if ageArray.contains("Young") {
            youngCell.accessoryType = .checkmark
        } else {
            youngCell.accessoryType = .none
        }
        
        if ageArray.contains("Adult") {
            adultCell.accessoryType = .checkmark
        } else {
            adultCell.accessoryType = .none
        }
        
        if ageArray.contains("Senior") {
            seniorCell.accessoryType = .checkmark
        } else {
            seniorCell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if ageArray.contains(ageStringIndex[cell.tag]) {
                ageArray = ageArray.filter { $0 != ageStringIndex[cell.tag] }
                updateAge()
                print(ageArray)
            }
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if !ageArray.contains(ageStringIndex[cell.tag]) {
                ageArray.insert(ageStringIndex[cell.tag], at: 0)
                updateAge()
                print(ageArray)
            }
        }
    }
    
    // HELPER FUNCTIONS
    
    func updateAge() {
        if ageArray.count == 5 {
            age = ""
        // If there's only one age param selected.
        // More effiecient to handle directly in the HTTP request
        } else if ageArray.count == 2 {
            age = ageArray[0]
        }
        else if ageArray.count == 1 {
            age = ""
            alertMustSelectAge()
        }
    }
    
    func resetAges() {
        ageArray = ["Baby", "Young", "Adult", "Senior", ""]
        print(ageArray)
        puppyCell.accessoryType = .checkmark
        youngCell.accessoryType = .checkmark
        adultCell.accessoryType = .checkmark
        seniorCell.accessoryType = .checkmark
    }
    
    func alertMustSelectAge() {
        let alertController = UIAlertController(title: "Age Must Be Selected", message: "Before leaving this page, make sure at least one Age is selected.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.resetAges()})
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
