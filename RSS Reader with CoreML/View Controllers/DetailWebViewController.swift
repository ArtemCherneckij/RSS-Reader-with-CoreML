//
//  DetailWebViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/12/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

class DetailWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var siteAdress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWebViewRequest(data: self.siteAdress!)
    }
    //Загрузка страницы
    func getWebViewRequest(data: String){
        let url = URL(string: data)
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.webView.loadRequest(request)
                    }
                }else{
                    print("Error: \(String(describing: error))")
                }
            }
            task.resume()
        }
        
    }
}
