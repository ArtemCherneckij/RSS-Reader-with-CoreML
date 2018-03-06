//
//  SettingsViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/2/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private let controller: Controller = Controller()
    @IBOutlet weak var backgroundColor: UIButton!
    @IBOutlet weak var clearCoreData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeBarTintColor), name: NSNotification.Name(rawValue: "ChangeBarTintColor"), object:nil)
        
        buttonDesign()
        setupGestures()
    }
    //Изменение дизайна кнопок
    func buttonDesign(){
        self.clearCoreData.layer.cornerRadius = 10
        self.clearCoreData.layer.shadowColor = UIColor.lightGray.cgColor
        self.clearCoreData.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.clearCoreData.layer.shadowRadius = 2.0
        self.clearCoreData.layer.shadowOpacity = 1.0
        self.clearCoreData.layer.masksToBounds = false;
        self.clearCoreData.layer.shadowPath = UIBezierPath(roundedRect:self.clearCoreData.bounds, cornerRadius:self.clearCoreData.layer.cornerRadius).cgPath
        
        self.backgroundColor.layer.cornerRadius = 10
        self.backgroundColor.layer.shadowColor = UIColor.lightGray.cgColor
        self.backgroundColor.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.backgroundColor.layer.shadowRadius = 2.0
        self.backgroundColor.layer.shadowOpacity = 1.0
        self.backgroundColor.layer.masksToBounds = false;
        self.backgroundColor.layer.shadowPath = UIBezierPath(roundedRect:self.backgroundColor.bounds, cornerRadius:self.backgroundColor.layer.cornerRadius).cgPath
    }
    //Удаление всех данных из CoreData
    @IBAction func removeDataFromCoreData(_ sender: Any) {
        self.controller.removeDataFromCoreData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: FetchDataFromCoreData.instance.fetchedObjects.count)
        self.controller.showNewsBadge()
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 1
        backgroundColor.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func tapped() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") else { return }
        
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.backgroundColor
        popOverVC?.sourceRect = CGRect(x: self.backgroundColor.bounds.midX, y: self.backgroundColor.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 220)
        
        self.present(popVC, animated: true)
    }
    
    @objc func changeBarTintColor(notification: Notification){
        navigationController?.navigationBar.barTintColor = notification.object as? UIColor
    }

}

extension SettingsViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
