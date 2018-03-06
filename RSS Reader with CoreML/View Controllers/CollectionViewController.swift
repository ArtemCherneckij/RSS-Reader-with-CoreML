//
//  CollectionViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var indexOfCell: Int!
    private let controller: Controller = Controller()
    private var uiAlertController: UIAlertController?
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reloadCollectionView"), object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeBarTintColor), name: NSNotification.Name(rawValue: "ChangeBarTintColor"), object:nil)
        
        self.uiAlertController = displaySignUpPendingAlert()
        self.controller.sendDataToParserFormNetwork(url: "https://lenta.ru/rss/news")
    }
    //Обновление CollectionView
    @objc func reloadCollectionView(){
        self.collectionView?.reloadData()
        self.uiAlertController?.dismiss(animated: true, completion: nil)
    }
    
    func displaySignUpPendingAlert() -> UIAlertController {
        
        let pending = UIAlertController(title: "Обновление данных", message: nil, preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        indicator.color = UIColor.black
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        self.present(pending, animated: true, completion: nil)
        
        return pending
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.getFetchedObjectsFromCoreData().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 10
        
        collectionView.cellForItem(at: indexPath)?.frame.size.height = 200
        
        cell.newsImage.frame.size.height = cell.layer.frame.size.height
        cell.newsImage.frame.size.width = cell.layer.frame.size.width
        
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 10
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.addDataToCell(data: self.controller.getFetchedObjectsFromCoreData()[indexPath.row])
    
        return cell
    }
    //Отправка уведомления для сокрытия TabBar Badge
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideNewsBadge"), object: nil)
    }
    //Определение какая ячейка будет нажата для дальнейшей передачи информации на DetailViewController
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.indexOfCell = indexPath.item
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"{
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.newsData = self.controller.getFetchedObjectsFromCoreData()[self.indexOfCell]
        }
    }
    //Обновление CollectionView
    @IBAction func reloadDataFromCollectionView(_ sender: Any) {
        self.controller.sendDataToParserFormNetwork(url: "https://lenta.ru/rss/news")
    }
    //Полуение цвета из SettingsView и изменение цвета бара
    @objc func changeBarTintColor(notification: Notification){
        navigationController?.navigationBar.barTintColor = notification.object as? UIColor
    }
}
