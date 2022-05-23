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
    var button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(isEdit)
        updateSaveButtonState()
        setupEyeButton()
    }
    
    @IBAction func tetxChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func btnPasswordVisibilityClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        let senderValue = (sender as! UIButton).isSelected
        toggleEyeButton(senderValue)
    }
    
    func setupEyeButton() {
        
        passwordTextField.rightViewMode = .unlessEditing
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .light)
        let boldSearch = UIImage(systemName: "eye.slash", withConfiguration: boldConfig)
        
        button.setImage(boldSearch, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.btnPasswordVisibilityClicked(_:)), for: .touchUpInside)
        
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
        
    }
    
    func toggleEyeButton(_ senderValue: Bool) {
        if senderValue {
            self.passwordTextField.isSecureTextEntry = false
            let boldConfig = UIImage.SymbolConfiguration(weight: .light)
            let boldSearch = UIImage(systemName: "eye", withConfiguration: boldConfig)
            button.setImage(boldSearch, for: .normal)
        } else {
            self.passwordTextField.isSecureTextEntry = true
            let boldConfig = UIImage.SymbolConfiguration(weight: .light)
            let boldSearch = UIImage(systemName: "eye.slash", withConfiguration: boldConfig)
            button.setImage(boldSearch, for: .normal)
        }

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




