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

    //MARK: - Private properties
    private let user = UserData.getUserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(inputPassText)
        let passCheck = SHAManager.shared.getHash(from: inputPassText)
        print(passCheck)
        
        if inputUserText == user.login && passCheck == user.passwordForAuthorization {
            return
        } else {
            showAlert(title: "Неверный логин или пароль", message: "Пожалуйста проверьте данные")
            passwordTextField.text = ""
        }
    }
}

extension FormViewController {

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            logIn()
            performSegue(withIdentifier: "showWelcomeVC", sender: nil)
        }
        return true
    }}

