//
//  EditSizeTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 1/2/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class EditSizeTableViewController: UITableViewController {
    
    let sizeIndex = [0, 1, 2, 3]
    let sizeStringIndex = ["S", "M", "L", "XL"]
    
    @IBOutlet weak var smallSizeCell: UITableViewCell!
    @IBOutlet weak var mediumSizeCell: UITableViewCell!
    @IBOutlet weak var largeSizeCell: UITableViewCell!
    @IBOutlet weak var extraLargeSizeCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SETUP SIZE
        if selectedSizeArray.contains("S") {
            smallSizeCell.accessoryType = .checkmark
        } else {
            smallSizeCell.accessoryType = .none
        }
        
        if selectedSizeArray.contains("M") {
            mediumSizeCell.accessoryType = .checkmark
        } else {
            mediumSizeCell.accessoryType = .none
        }
        
        if selectedSizeArray.contains("L") {
            largeSizeCell.accessoryType = .checkmark
        } else {
            largeSizeCell.accessoryType = .none
        }
        
        if selectedSizeArray.contains("XL") {
            extraLargeSizeCell.accessoryType = .checkmark
        } else {
            extraLargeSizeCell.accessoryType = .none
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if selectedSizeArray.contains(sizeStringIndex[cell.tag]) {
                selectedSizeArray = selectedSizeArray.filter { $0 != sizeStringIndex[cell.tag] }
                updateSize()
                print(selectedSizeArray)
            }
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            if !selectedSizeArray.contains(sizeStringIndex[cell.tag]) {
                selectedSizeArray.insert(sizeStringIndex[cell.tag], at: 0)
                updateSize()
                print(selectedSizeArray)
            }
        }
    }
    
    // HELPER FUNCTIONS
    
    func updateSize() {
        if selectedSizeArray.count == 5 {
            breedSize = ""
        // If there's only one size param selected.
        // More effiecient to handle directly in the HTTP request
        } else if selectedSizeArray.count == 2 {
            breedSize = selectedSizeArray[0]
        }
        else if selectedSizeArray.count == 1 {
            breedSize = ""
            alertMustSelectSize()
        }
    }
    
    func resetSizes() {
        selectedSizeArray = ["S", "M", "L", "XL", ""]
        print(selectedSizeArray)
        smallSizeCell.accessoryType = .checkmark
        mediumSizeCell.accessoryType = .checkmark
        largeSizeCell.accessoryType = .checkmark
        extraLargeSizeCell.accessoryType = .checkmark
    }
    
    func alertMustSelectSize() {
        let alertController = UIAlertController(title: "Size Must Be Selected", message: "Before leaving this page, make sure at least one size is selected.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.resetSizes()})
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
