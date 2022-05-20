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
    private let userData = UserData.getUserData()
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarController = segue.destination as? UITabBarController else { return }
        guard let viewControllers = tabBarController.viewControllers else { return }
        
        viewControllers.forEach {
            if let welcomeVC = $0 as? MasterKeyViewController {
                welcomeVC.user = user
            } else if let navigationVC = $0 as? UINavigationController {
                let userInfo = navigationVC.topViewController as! UserInfoViewController
                userInfo.user = user
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logIn(_ sender: Any) {
    }
    

}

