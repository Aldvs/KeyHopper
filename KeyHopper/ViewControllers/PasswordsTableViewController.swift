//
//  TableViewController.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import UIKit

class PasswordsTableViewController: UITableViewController {
 
    var entityes = [
        UserData(nameOfAccount: "sdfsdf", password: "sdfsdf", hint: "sdfsdfsdf", login: "sdfsdfsdf", passwordForAuthorization: "sdfsdfdsf"),
        UserData(nameOfAccount: "1111111", password: "dfsfsdfs", hint: "111111", login: "dsfsdf", passwordForAuthorization: "sdfsdfsdfs")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ваши пароли"
        self.navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Редактировать"
        }


    // MARK: - Navigation Methods
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! SettingsTableViewController
        let entity = sourceVC.entity
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            entityes[selectedIndexPath.row] = entity
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: entityes.count, section: 0)
            entityes.append(entity)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editData" else { return }
        
        let indexPath = tableView.indexPathForSelectedRow!
        let entity = entityes[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEntityVC = navigationVC.topViewController as! SettingsTableViewController
        
        newEntityVC.entity = entity
        newEntityVC.title = "Настройка"
    }
    
    //MARK: - Override wethods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.editButtonItem.title = "Завершить"
        }
        else {
            self.editButtonItem.title = "Редактирование"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! DataTableViewCell

        let entity = entityes[indexPath.row]
        cell.set(object: entity)
        
        return cell
    }
    
    //MARK: - Editing Cells Methods
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entityes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedAccount = entityes.remove(at: sourceIndexPath.row)
        entityes.insert(movedAccount, at: destinationIndexPath.row)
        tableView.reloadData()
    }

}
