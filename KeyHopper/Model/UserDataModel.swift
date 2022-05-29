//
//  PasswordModel.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import Foundation

struct UserData {
    
    //MARK: - Public properties
    var nameOfAccount: String = ""
    var password: String = ""
    var hint: String = ""
    
    var login: String
    var passwordForAuthorization: String
    
    //MARK: - Public methods
    static func getUserData() -> UserData {
        UserData(
            login: "user",
            passwordForAuthorization: "cd22f62d410f2c8543f241d3e55389b0e36baead8503a49d20faef79fc4ba6c5")
    }
}

