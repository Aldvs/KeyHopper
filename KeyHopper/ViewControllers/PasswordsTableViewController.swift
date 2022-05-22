//
//  TableViewController.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import UIKit

class PasswordsTableViewController: UITableViewController {
 
//    var entityes = [
//        UserData(nameOfAccount: "sdfsdf", password: "sdfsdf", hint: "sdfsdfsdf", login: "sdfsdfsdf", passwordForAuthorization: "sdfsdfdsf"),
//        UserData(nameOfAccount: "1111111", password: "dfsfsdfs", hint: "111111", login: "dsfsdf", passwordForAuthorization: "sdfsdfsdfs")
//    ]
    var dataList: [DataEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ваши пароли"
        self.navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Редактировать"
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }

    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                self.dataList = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Navigation Methods
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! SettingsTableViewController
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow, let updatedData = sourceVC.editData {
            dataList[selectedIndexPath.row] = updatedData
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let account = sourceVC.accountTextField.text ?? ""
            let password = sourceVC.passwordTextField.text ?? ""
            let hint = sourceVC.hintTextField.text ?? ""
            StorageManager.shared.save(account, password, hint) { data in
                data.accountName = account
                data.password = password
                data.hint = hint
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "editData" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let data = dataList[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let editDataVC = navigationVC.topViewController as! SettingsTableViewController
            editDataVC.title = "Настройка"
            editDataVC.editData = data
            editDataVC.isEdit = true
            
        } else if segue.identifier == "addData" {
            
            let navigationVC = segue.destination as! UINavigationController
            let addDataVC = navigationVC.topViewController as! SettingsTableViewController
            addDataVC.title = "Новый аккаунт"
            addDataVC.isEdit = false
        }
        
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
        return dataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! DataTableViewCell

        let data = dataList[indexPath.row]
        cell.set(object: data)
        
        return cell
    }
    
    //MARK: - Editing Cells Methods
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = dataList[indexPath.row]
        if editingStyle == .delete {
            dataList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            StorageManager.shared.delete(data)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let movedAccount = dataList.remove(at: sourceIndexPath.row)
        StorageManager.shared.delete(movedAccount)
        dataList.insert(movedAccount, at: destinationIndexPath.row)
        tableView.reloadData()
        let readyAccount = dataList[destinationIndexPath.row]
        let account = readyAccount.accountName ?? ""
        let password = readyAccount.password ?? ""
        let hint = readyAccount.hint ?? ""
        StorageManager.shared.save(account, password, hint) { data in
            data.accountName = account
            data.password = password
            data.hint = hint
        }
    }

}
