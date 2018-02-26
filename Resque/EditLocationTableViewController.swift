//
//  EditLocationTableViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 1/1/18.
//  Copyright © 2018 Roback, Jerry. All rights reserved.
//

import UIKit

class EditLocationTableViewController: UITableViewController {

    @IBOutlet weak var useCurrentLocationSwitch: UISwitch!
    @IBOutlet weak var editZipCodeCell: UITableViewCell!
    @IBOutlet weak var currentZipCodeInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        useCurrentLocationSwitch.isOn = !manualZipCode
        currentZipCodeInput.delegate = self
        
        if manualZipCode == false {
            useCurrentLocationSwitch.isOn = true
            editZipCodeCell.isHidden = true
        } else {
            useCurrentLocationSwitch.isOn = false
            editZipCodeCell.isHidden = false
        }
        currentZipCodeInput.text = zipCode
        
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.tableView, action: #selector(UIView.endEditing(_:))))
    }
    
    func toggleLocationSwitch() {
        useCurrentLocationSwitch.isOn = !useCurrentLocationSwitch.isOn
        if useCurrentLocationSwitch.isOn {
            editZipCodeCell.isHidden = true
            manualZipCode = false
        } else {
            editZipCodeCell.isHidden = false
            currentZipCodeInput.becomeFirstResponder()
            
            // TODO: This doesn't work. Needs to be in a different place or implement text input delegate?
            if currentZipCodeInput.text != nil {
                validateZipCode(enteredZipCode: currentZipCodeInput.text!)
                manualZipCode = true
                zipCode = currentZipCodeInput.text!
            }
        }
    }
    
    // Helper Functions
    
    public func validateZipCode(enteredZipCode: String) {
        if enteredZipCode.count == 5 && Int(enteredZipCode) != nil {
            zipCode = enteredZipCode
            manualZipCode = true
        } else {
            print("Please enter a valid 5 digit Zipcode")
            let alertController = UIAlertController(title: "Invalid Zipcode", message: "Please enter a valid 5 digit Zipcode.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.currentZipCodeInput.becomeFirstResponder()})
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    
    @IBAction func locationSwitchDidToggle(_ sender: Any) {
        toggleLocationSwitch()
        self.tableView.reloadData()
    }
}

extension EditLocationTableViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentZipCodeInput.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentZipCodeInput.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateZipCode(enteredZipCode: textField.text!)
    }
}
