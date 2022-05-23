//
//  DataManager.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import Foundation

struct MainKey {
    var key: String
    
    static func getMainKey() -> MainKey {
        MainKey(key: "8899aabbccddeeff0011223344556677fedcba98765432100123456789abcdef")
    }
}
