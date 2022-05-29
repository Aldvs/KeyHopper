//
//  TableViewController.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import UIKit

class PasswordsTableViewController: UITableViewController {
    
    //MARK: - Public methods
    var dataList: [DataEntity] = []
    var keyList: [MasterKey] = []
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ваши пароли"
        self.navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Редактировать"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        fetchKey()
        tableView.reloadData()
    }
    
    // MARK: - Navigation Methods
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let setupVC = segue.source as! SettingsTableViewController
        
        //редактирование по нажатию на ячейку ПРИХОД ДАННЫХ
        if let selectedIndexPath = tableView.indexPathForSelectedRow, let updatedData = setupVC.setupedData {
            //обновление таблицы
            dataList[selectedIndexPath.row] = updatedData
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // редактирование по нажатию на ячейку УХОД ДАННЫХ
        if segue.identifier == "editData" {
            let indexPath = tableView.indexPathForSelectedRow!
            let data = dataList[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let setupDataVC = navigationVC.topViewController as! SettingsTableViewController
            setupDataVC.title = "Настройка"
            setupDataVC.setupedData = data //трансфер выбранных данных на экран настройки
            setupDataVC.isEdit = true
            
        // новая запись УХОД ДАННЫХ
        } else if segue.identifier == "addData" {
            let navigationVC = segue.destination as! UINavigationController
            let setupDataVC = navigationVC.topViewController as! SettingsTableViewController
            setupDataVC.title = "Новый аккаунт"
            setupDataVC.isEdit = false
        }
    }
}

//MARK: - Extension
extension PasswordsTableViewController {
    
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
        dataList.insert(movedAccount, at: destinationIndexPath.row)
        tableView.reloadData()
    }
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
}
