//
//  SHAManager.swift
//  KeyHopper
//
//  Created by admin on 19.05.2022.
//

import Foundation
import CryptoKit

class SHAManager {
    
    //MARK: - Public properties
    static var shared = SHAManager()
    
    //MARK: - Public methods
    func getHash(from password: String) -> String {

        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        let hash = digest.compactMap { String(format: "%02x", $0)}.joined()
        return hash
    }
    
    private init() {}
}
