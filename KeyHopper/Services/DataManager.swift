//
//  DataManager.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    let login = "User"
    let password = "Password"

    private init() {}
    
}

struct MasterKey {
    var key: String
    
    static func getMasterKey() -> MasterKey {
        MasterKey(key: "8899aabbccddeeffrr11223344556677fedcba98765432100123456789abcdef")
    }
}
