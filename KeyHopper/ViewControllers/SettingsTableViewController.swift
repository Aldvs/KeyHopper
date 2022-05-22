//
//  SettingsTableViewController.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hintTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var editData: DataEntity!
    var isEdit: Bool!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(isEdit)
        updateSaveButtonState()
    }
    
    @IBAction func tetxChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    //MARK: - Private Methods
    private func updateSaveButtonState() {
        let accountText = accountTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        //        let hintText = hintTextField.text ?? ""
        
        saveButton.isEnabled = !accountText.isEmpty && !passwordText.isEmpty
        
    }
    
    private func updateUI(_ editMode: Bool) {
        
        if isEdit {
            accountTextField.text = editData.accountName ?? ""
            passwordTextField.text = editData.password ?? ""
            hintTextField.text = editData.hint ?? ""
        } else {
            accountTextField.text = ""
            passwordTextField.text = ""
            hintTextField.text = ""

        }
    }

    //MARK: - Override Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        
        if let name = accountTextField.text, let password = passwordTextField.text , let hint = hintTextField.text, let newData = editData{
            StorageManager.shared.edit(newData, newName: name, newPassword: password, newHint: hint)

        }

    }

}




