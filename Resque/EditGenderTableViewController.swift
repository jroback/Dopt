//
//  EditGenderTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 1/4/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit


class EditGenderTableViewController: UITableViewController {
    
    let genderIndex = [0, 1]
    let genderStringIndex = ["F", "M"]

    @IBOutlet weak var femaleCell: UITableViewCell!
    @IBOutlet weak var maleCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGender()
        
        // SETUP GENDER
        if !genderArray.contains("M") && !genderArray.contains("F") {
            femaleCell.accessoryType = .none
            maleCell.accessoryType = .none
        } else if genderArray.contains("M") && genderArray.contains("F"){
            femaleCell.accessoryType = .checkmark
            maleCell.accessoryType = .checkmark
        } else if genderArray.contains("M") {
            maleCell.accessoryType = .checkmark
            femaleCell.accessoryType = .none
        } else if genderArray.contains("F") {
            femaleCell.accessoryType = .checkmark
            maleCell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if genderArray.contains(genderStringIndex[cell.tag]) {
                genderArray = genderArray.filter { $0 != genderStringIndex[cell.tag] }
                updateGender()
                print(genderArray)
            }

        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if !genderArray.contains(genderStringIndex[cell.tag]) {
                genderArray.insert(genderStringIndex[cell.tag], at: 0)
                updateGender()
                print(genderArray)
            }
        }
    }
    
    // HELPER FUNCTIONS
    
    func updateGender() {
        if genderArray.count == 3 {
            searchSex = ""
        } else if genderArray.count == 2 {
            searchSex = genderArray[0]
        } else {
            searchSex = ""
            alertMustSelectGender()
        }
    }
    
    func resetGender() {
        genderArray = ["F", "M", ""]
        print(genderArray)
        maleCell.accessoryType = .checkmark
        femaleCell.accessoryType = .checkmark
    }
    
    func alertMustSelectGender() {
        let alertController = UIAlertController(title: "Gender Must Be Selected", message: "Before leaving this page, make sure at least one gender is selected.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.resetGender()})
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
