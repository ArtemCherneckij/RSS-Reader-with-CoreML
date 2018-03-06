//
//  Controller.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/2/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation

class Controller: NSObject {
    
    private let xmlParser: Parser = Parser()
    private let networkSession: NetworkSession = NetworkSession()
    
    //Получение XML файла из сети и его парсинг
    @objc
    func sendDataToParserFormNetwork(url: String){
        networkSession.downloadData(siteAdress: url) { (data) in
            if String(data: data, encoding: .utf8) != "error" {
                self.xmlParser.parseData(data: data) {(news) in
                    self.checkForNovelty(downloadNews: news)
                }
                self.xmlParser.news.removeAll()
            }else{
                self.xmlParser.news.removeAll()
            }
        }
    }
    
    func checkForNovelty(downloadNews: [News]){
        FetchDataFromCoreData.instance.fetchDataFromCoreData{
            switch FetchDataFromCoreData.instance.fetchedObjects.count {
            case 0:
                InsertDataToCoreData.instance.insertDataToCoreData(newsArray: downloadNews)
                FetchDataFromCoreData.instance.fetchDataFromCoreData {
                    print(FetchDataFromCoreData.instance.fetchedObjects.count)
                    print("Новости добавлены!")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: FetchDataFromCoreData.instance.fetchedObjects.count)
                        self.showNewsBadge()
                    }
                }
            default:
                for object in FetchDataFromCoreData.instance.fetchedObjects {
                    if object.id == 0{
                        if downloadNews.first?.title != object.title {
                            FetchDataFromCoreData.instance.removeInfoFromCoreData()
                            InsertDataToCoreData.instance.insertDataToCoreData(newsArray: downloadNews)
                            FetchDataFromCoreData.instance.fetchDataFromCoreData {
                                print(FetchDataFromCoreData.instance.fetchedObjects.count)
                                print("Новости обновлены!")
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: FetchDataFromCoreData.instance.fetchedObjects.count)
                                    self.showNewsBadge()
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: FetchDataFromCoreData.instance.fetchedObjects.count)
                                self.showNewsBadge()
                            }
                            print("У вас актуальная версия новостей!")
                        }
                    }
                }
            }
        }
    }
    
    //Получение массива данных извлеченных из CoreData
    func getFetchedObjectsFromCoreData() -> [RSSData] {
        return FetchDataFromCoreData.instance.fetchedObjects
    }
    
    //Отправление post для изменения значений TabBar Badge
    func showNewsBadge(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showNewsBadge"), object: FetchDataFromCoreData.instance.fetchedObjects.count)
    }
    
    //Удаление данных из CoreData
    func removeDataFromCoreData(){
        FetchDataFromCoreData.instance.removeInfoFromCoreData()
        self.xmlParser.news.removeAll()
    }
}
