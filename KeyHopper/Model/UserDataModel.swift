//
//  PasswordModel.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import Foundation

struct UserData {
    
    var nameOfAccount: String = ""
    var password: String = ""
    var hint: String = ""
    
    var login: String
    var passwordForAuthorization: String
    
    static func getUserData() -> UserData {
        UserData(
            login: "user",
            passwordForAuthorization: "password")
    }
}

