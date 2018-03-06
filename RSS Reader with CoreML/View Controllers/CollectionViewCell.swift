//
//  CollectionViewCell.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/1/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private let networkSession: NetworkSession = NetworkSession()
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    //Добавления данных на ViewCell
    func addDataToCell(data: RSSData){
        self.newsTitle.text = data.title
        //Проверка на то, есть ли уже у ячейки sublayer, если нет до добавляем градиентный слой
        if self.newsImage.layer.sublayers?.isEmpty == nil {
            self.newsImage.layer.insertSublayer(createGradient(), at: UInt32(0))
        }
        //Загрузка изображения для ячейки
        if data.image != ""{
            self.networkSession.downloadData(siteAdress: data.image!) { (data) in
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: data)
                }
            }
        }
    }
    //Создание градиента для ячейки
    func createGradient() -> CAGradientLayer{
        let gradient : CAGradientLayer = CAGradientLayer()
        let arrayColors:Array<AnyObject> = [UIColor.clear.cgColor, UIColor.lightGray.cgColor]
        gradient.colors = arrayColors
        gradient.frame = self.newsImage.bounds
        gradient.opacity = 1
        
        return gradient
    }
}
