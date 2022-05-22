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
    
    private var masterKey = MainKey.getMainKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewContorller()
    }
    
    @IBAction func getMasterKey() {
        generateRandomMasterKey(masterKey: masterKey.key)
        keyImage.isHidden = true
        generateButton.isHidden = true
        checkMarkImage.isHidden = false
    }
    
    private func setupViewContorller() {
        checkMarkImage.isHidden = true
    }
    
    private func generateRandomMasterKey(masterKey key: String) {
//        var resultMasterKey = ""
        let shuffledKey = masterKey.key.shuffled()
        masterKey.key = ""
        for ch in shuffledKey {
            masterKey.key.append(ch)
        }
        print(masterKey.key)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
