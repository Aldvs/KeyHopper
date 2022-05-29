//
//  MasterKeyViewController.swift
//  KeyHopper
//
//  Created by admin on 20.05.2022.
//

import UIKit

class MasterKeyViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    
    //MARK: - Public properties
    var keyList: [MasterKey] = []
    
    //MARK: - Private properties
    private var mainKey = MainKey.getMainKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchKey()
//        deleteKey()
//        print(keyList[0].key)
        setupViewContorller()
    }

//    private func deleteKey() {
//        StorageManager.shared.delete(keyList[0])
//    }
    //MARK: - IB Actions
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
    
    //MARK: - Private methods
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
        var resultKey = ""
        let shuffledKey = mainKey.key.shuffled()
        for ch in shuffledKey {
            resultKey.append(ch)
        }
        
        return resultKey
    }
}
