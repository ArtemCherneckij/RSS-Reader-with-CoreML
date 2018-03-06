//
//  TabBarViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var newsBadge = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Добавление обозревателя для изменения значений TabBar Badge
        NotificationCenter.default.addObserver(self, selector: #selector(showNewsBadge), name: NSNotification.Name(rawValue: "showNewsBadge"), object:nil)
        self.newsBadge = tabBar.items![0]
        //Добавление обозревателя для сокрытия TabBar Badge
        NotificationCenter.default.addObserver(self, selector: #selector(hideNewsBadge), name: NSNotification.Name(rawValue: "hideNewsBadge"), object:nil)
        
    }
    //Получение значений о количестве новостей и обновление значения TabBar Badge
    @objc func showNewsBadge(notification: Notification){
        if String(describing: notification.object!) != "0"{
            newsBadge.badgeValue = String(describing: notification.object!)
        }else{
            newsBadge.badgeValue = nil
        }
    }
    //Сокрытие TabBar Badge
    @objc func hideNewsBadge(){
        newsBadge.badgeValue = nil
    }
}
