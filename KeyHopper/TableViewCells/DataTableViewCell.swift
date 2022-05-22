//
//  DataCell.swift
//  KeyHopper
//
//  Created by admin on 18.05.2022.
//

import Foundation
import UIKit

class DataTableViewCell: UITableViewCell {
    
    //MARK: - IB Outlets
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Public Methods
    func set(object: DataEntity) {
        self.nameLabel.text = object.accountName
    }
}
