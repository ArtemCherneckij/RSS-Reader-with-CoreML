//
//  InsertDataToCoreData.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class InsertDataToCoreData: NSObject {
    
    static let instance = InsertDataToCoreData()
    
    //Вставка данных в CoreData
    func insertDataToCoreData(newsArray: [News]){
        for index in 0..<newsArray.count {
            let ObjectContext = NSEntityDescription.insertNewObject(forEntityName: "RSSData", into: CoreDataManager.instance.managedObjectContextPrivateQueue) as! RSSData
            ObjectContext.id = Int16(index)
            ObjectContext.title = newsArray[index].title
            ObjectContext.guid = newsArray[index].guid
            ObjectContext.descriptionnews = newsArray[index].descriptionNews
            ObjectContext.pubdate = newsArray[index].pubDate
            ObjectContext.image = newsArray[index].image
            ObjectContext.category = newsArray[index].category
        }
        CoreDataManager.instance.savePrivateContext()
    }
}
