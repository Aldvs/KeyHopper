//
//  MasterKeyViewController.swift
//  KeyHopper
//
//  Created by admin on 20.05.2022.
//

import UIKit

class MasterKeyViewController: UIViewController {

    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    
    private var mainKey = MainKey.getMainKey()
    
    var keyList: [MasterKey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchKey()
//        deleteKey()
        setupViewContorller()
    }
    
//    private func deleteKey() {
//        StorageManager.shared.delete(keyList[0])
//    }
    
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
    
    @IBAction func getMasterKey() {
        
        keyImage.isHidden = true
        generateButton.isHidden = true
        checkMarkImage.isHidden = false
        
        let flag = true
        let key = generateRandomMasterKey(masterKey: mainKey.key)

        StorageManager.shared.save(key, flag) { masterKey in
            masterKey.key = key
            masterKey.flag = flag
        }
        
    }
    
    private func setupViewContorller() {
        
        if keyList.isEmpty {
            checkMarkImage.isHidden = true
        } else {
            keyImage.isHidden = true
            generateButton.isHidden = true
            checkMarkImage.isHidden = false
            print(keyList[0].key ?? "")
        }
    }
    
    private func generateRandomMasterKey(masterKey key: String) -> String {
//        var resultKey = ""
//        let shuffledKey = mainKey.key.shuffled()
//        mainKey.key = ""
//        for ch in shuffledKey {
//            resultKey.append(ch)
//        }
//        return resultKey
        return key
//        print(mainKey.key)
    }
}
