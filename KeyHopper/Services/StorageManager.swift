//
//  StorageManager.swift
//  KeyHopper
//
//  Created by admin on 21.05.2022.
//

import CoreData

class StorageManager {

    static let shared = StorageManager()

    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let viewContext: NSManagedObjectContext

    private init() {
        viewContext = persistentContainer.viewContext
    }

    //MARK: - Public Properties
    func fetchData(complition: (Result<[DataEntity], Error>) -> Void) {
        let fetchRequest = DataEntity.fetchRequest()

        do {
            let dataEntityes = try viewContext.fetch(fetchRequest)
            complition(.success(dataEntityes))
        } catch let error {
            complition(.failure(error))
        }
    }

    func save(_ account: String,_ password: String,_ hint: String,  completion: (DataEntity) -> Void) {
        let dataEntity = DataEntity(context: viewContext)
        dataEntity.accountName = account
        dataEntity.password = password
        dataEntity.hint = hint
        completion(dataEntity)
        saveContext()
    }
    func edit(_ entity: DataEntity, newName: String, newPassword: String, newHint: String) {
        entity.accountName = newName
        entity.password = newPassword
        entity.hint = newHint
        saveContext()
    }
    func delete(_ entity: DataEntity) {
        viewContext.delete(entity)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

