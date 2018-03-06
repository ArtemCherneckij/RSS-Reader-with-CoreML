//
//  CoreDataModel.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    //Core Data Singelton
    static let instance = CoreDataManager(modelName: "RSS_Reader_with_CoreML")
    
    private let modelName: String
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    //Private Queue Context
    lazy var managedObjectContextPrivateQueue: NSManagedObjectContext = {
        let managedObjectContextPrivateQueue = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContextPrivateQueue.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContextPrivateQueue
    }()
    
    //Main Queue Context
    lazy var managedObjectContextMainQueue: NSManagedObjectContext = {
        let managedObjectContextMainQueue = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContextMainQueue.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContextMainQueue
    }()
    
    //Создание ManagedObjectModel
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else{
            fatalError("Unable to find data model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)else{
            fatalError("Unable to load data model")
        }
        
        return managedObjectModel
    }()
    
    //Создание PersistentStoreCoordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do{
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        }catch{
            fatalError("Unable to load persistent store")
        }
        
        return persistentStoreCoordinator
    }()
    
    //Сохранение контекста
    func savePrivateContext () {
        if managedObjectContextPrivateQueue.hasChanges {
            do {
                try managedObjectContextPrivateQueue.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMainContext () {
        if managedObjectContextMainQueue.hasChanges {
            do {
                try managedObjectContextMainQueue.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

