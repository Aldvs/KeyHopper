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
    
    //    var dataList: [DataEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateUI()
        
        updateSaveButtonState()
    }
    
    @IBAction func tetxChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
//    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
//        let account = accountTextField.text ?? ""
//        let password = passwordTextField.text ?? ""
//        let hint = hintTextField.text ?? ""
//        StorageManager.shared.save(account, password, hint) { data in
//            data.accountName = account
//            data.password = password
//            data.hint = hint
//        }
//    }
    
    //MARK: - Private Methods
    private func updateSaveButtonState() {
        let accountText = accountTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        //        let hintText = hintTextField.text ?? ""
        
        saveButton.isEnabled = !accountText.isEmpty && !passwordText.isEmpty
        
    }
}

//    private func updateUI() {
//        accountTextField.text = entity.nameOfAccount
//        passwordTextField.text = entity.password
//        hintTextField.text = entity.hint
//    }


//    //MARK: - Override Methods
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        guard segue.identifier == "saveSegue" else { return }
//
//        let name = accountTextField.text ?? ""
//        let password = passwordTextField.text ?? ""
//        let hint = hintTextField.text ?? ""

//        self.entity = UserData(nameOfAccount: name, password: password, hint: hint, login: "", passwordForAuthorization: "")

//    }

