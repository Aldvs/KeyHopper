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
    
    var keyList: [MasterKey] = []
    var setupedData: DataEntity!
    
    var isEdit: Bool!
    var button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchKey()
        updateUI(isEdit)
 
        updateSaveButtonState()
        setupEyeButton()
    }
    
    @IBAction func textChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func btnPasswordVisibilityClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        let senderValue = (sender as! UIButton).isSelected
        toggleEyeButton(senderValue)
    }
    
    
    //MARK: - Private Methods
    private func updateSaveButtonState() {
        
        let accountText = accountTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        saveButton.isEnabled = !accountText.isEmpty && !passwordText.isEmpty && passwordText.count == 32
    }
    
    private func updateUI(_ editMode: Bool) {
        
        if isEdit, let key = keyList[0].key, let passwordForUserEyes = setupedData.password {
            accountTextField.text = setupedData.accountName ?? ""
            passwordTextField.text = CryptoManager.shared.decryptionFunc(entireText: passwordForUserEyes, master: key)
            hintTextField.text = setupedData.hint ?? ""
            
        } else {
            accountTextField.text = ""
            passwordTextField.text = ""
            hintTextField.text = ""

        }
    }

    //MARK: - Navigation method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }

        guard let masterKey = keyList[0].key else { return }
        
        if isEdit == false,
           let account = accountTextField.text,
           let password = passwordTextField.text,
           let hint = hintTextField.text {
            
            let securedPassword = CryptoManager.shared.encryptionFunc(block: password, master: masterKey)
            print("ЗАШИФРОВАННЫЙ ПАРОЛЬ ПОСЛЕ СОЗДАНИЯ НОВОГО ПАРОЛЯ (ТО ЧТО ВОШЛО В БД ПОСЛЕ СОЗДАНИЯ)")
            print(securedPassword)
            StorageManager.shared.save(account, securedPassword, hint) { data in
                data.accountName = account
                data.password = securedPassword
                data.hint = hint
            }
            
        } else {
            
            if let name = accountTextField.text, let password = passwordTextField.text, let master = keyList[0].key , let hint = hintTextField.text, let editedData = setupedData {
                let encryptedPassword = CryptoManager.shared.encryptionFunc(block: password, master: master)
                print("ЗАШИФРОВАННЫЙ ПАРОЛЬ ПОСЛЕ РЕДАКТИРОВАНИЯ:")
                print(encryptedPassword)
                StorageManager.shared.edit(editedData, newName: name, newPassword: encryptedPassword, newHint: hint)
            }
        }
    }
//        if let name = accountTextField.text, let password = passwordTextField.text, let master = keyList[0].key , let hint = hintTextField.text, let editedData = setupedData {
//            let encryptedPassword = CryptoManager.shared.encryptionFunc(block: password, master: master)
//            print("ЗАШИФРОВАННЫЙ ПАРОЛЬ ПОСЛЕ ПРОСМОТРА ЛИБО РЕДАКТИРОВАНИЯ:")
//            print(encryptedPassword)
//            StorageManager.shared.edit(editedData, newName: name, newPassword: encryptedPassword, newHint: hint)
//        }

}

extension SettingsTableViewController {
    
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
    
    private func fetchKey() {
        StorageManager.shared.fetchKey { result in
            switch result {
            case .success(let keys):
                self.keyList = keys
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}




