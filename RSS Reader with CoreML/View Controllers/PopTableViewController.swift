//
//  PopTableViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/14/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

class PopTableViewController: UITableViewController {
    
    let colorArray = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.3300932944, blue: 0.2421161532, alpha: 1),#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colorArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.backgroundColor = self.colorArray[indexPath.row]
        
        return cell
    }
    //Отправка нотификации, какой цвет бара был выбран
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBarTintColor"), object: self.colorArray[indexPath.row])
    }
}

