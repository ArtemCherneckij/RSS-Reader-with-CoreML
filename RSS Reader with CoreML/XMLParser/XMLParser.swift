//
//  XMLParser.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation

class Parser: NSObject, XMLParserDelegate{
    
    var news: [News] = []
    var sourceName = String()
    
    private var eName: String = String()
    private var title = String()
    private var link = String()
    private var descriptionNews: String = String()
    private var pubDate = String()
    private var guid = String()
    private var image = String()
    private var category = String()
    
    //Парсинг данных
    func parseData(data: Data, completion: @escaping (([News]) -> Void)){
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        completion(self.news)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        
        if elementName == "item"{
            title = String()
            link = String()
            descriptionNews = String()
            pubDate = String()
            guid = String()
            image = String()
            category = String()
        }
        
        if elementName == "enclosure" {
            if let url = attributeDict["url"] {
                self.image = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if eName == "title" {
                title += data
                if sourceName == ""{
                    sourceName += data
                }
            }else if eName == "link" {
                link += data
            }else if eName == "description"{
                descriptionNews += data
            }else if eName  == "pubDate"{
                pubDate += data
            }else if eName == "guid"{
                guid += data
            }else if eName == "category"{
                category += data
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"{
            
            let new = News()
            
            new.title = title
            new.link = link
            new.descriptionNews = descriptionNews
            new.pubDate = pubDate
            new.guid = guid
            new.image = image
            new.category = category
            
            news.append(new)
        }
    }
}

