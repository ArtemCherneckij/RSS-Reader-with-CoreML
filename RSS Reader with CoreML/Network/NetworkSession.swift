//
//  NetworkSession.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import Foundation
//Сессия для загрузки данных
class NetworkSession {
    
    func downloadData(siteAdress: String, completion: @escaping ((Data) -> Void)) {
        let stringURL = URL(string: siteAdress)
        let urlRequest = URLRequest(url: stringURL!)
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                let str = "error"
                let dataError = str.data(using: .utf8)
                completion(dataError!)
            }else{
                completion(data!)
            }
        }
        urlTask.resume()
    }
    
}
