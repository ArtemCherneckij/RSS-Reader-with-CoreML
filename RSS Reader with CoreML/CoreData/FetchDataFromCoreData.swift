//
//  FetchDataFromCoreData.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation
import CoreData

class FetchDataFromCoreData: NSObject {
    
    static let instance = FetchDataFromCoreData()
    //Извлеченные из CoreData данные
    var fetchedObjects: [RSSData] = []
    //Извлечение данных из CoreData
    func fetchDataFromCoreData(completion: @escaping (() -> Void)) {
        let fetchRequest = NSFetchRequest<RSSData>(entityName: "RSSData")
        do{
            let fetchResult = try CoreDataManager.instance.managedObjectContextMainQueue.fetch(fetchRequest) as [RSSData]
            self.fetchedObjects = fetchResult
            self.fetchedObjects.sort(by: {$0.id < $1.id})
        }catch{
            fatalError("Failed to fetch news: \(error)")
        }
        completion()
    }
    //Удаление данных из CoreData
    func removeInfoFromCoreData(){
        fetchDataFromCoreData{
            for index in 0..<self.fetchedObjects.count{
                CoreDataManager.instance.managedObjectContextMainQueue.delete(self.fetchedObjects[index] as NSManagedObject)
            }
        }
        fetchedObjects.removeAll()
        CoreDataManager.instance.saveMainContext()
    }
}

