//
//  ViewController.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import UIKit

class FormViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let button = UIButton(type: .custom)
    //MARK: - Private properties
    private let user = UserData.getUserData()
    
    //MARK: Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEyeButton()
    }

    //MARK: IB Actions
    @IBAction func btnPasswordVisibilityClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        let senderValue = (sender as! UIButton).isSelected
        toggleEyeButton(senderValue)
    }
    
    @IBAction func logIn() {
        
        guard let inputUserText = loginTextField.text, !inputUserText.isEmpty else {
            showAlert(title: "Пустое поля логина", message: "Пожалуйста, введите свой логина")
            return
        }
        
        if let _ = Double(inputUserText) {
            showAlert(title: "Неверный формат", message: "В поле логина не должно быть цифр")
            return
        }
        
        guard let inputPassText = passwordTextField.text, !inputPassText.isEmpty else {
            showAlert(title: "Пустое поле пароля", message: "Пожалуйста, введите пароль")
            return
        }
        
        let passCheck = SHAManager.shared.getHash(from: inputPassText)
        
        if inputUserText == user.login && passCheck == user.passwordForAuthorization {
            return
        } else {
            showAlert(title: "Неверный логин или пароль", message: "Пожалуйста проверьте данные")
            passwordTextField.text = ""
        }
    }
    
    //MARK: - Private methods
    private func setupEyeButton() {
        
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
    
    private func toggleEyeButton(_ senderValue: Bool) {
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
}

//MARK: - Extentions
extension FormViewController {

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            logIn()
            performSegue(withIdentifier: "showWelcomeVC", sender: nil)
        }
        return true
    }
}

