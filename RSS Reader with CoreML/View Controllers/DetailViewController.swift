//
//  DetailViewController.swift
//  RSS Reader with CoreML
//
//  Created by Artsiom Charnetski on 2/2/18.
//  Copyright © 2018 Artsiom Charnetski. All rights reserved.
//

import UIKit
import Vision

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private let networkSession: NetworkSession = NetworkSession()
    
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var descriptionOfNews: UILabel!
    @IBOutlet weak var imageOfNews: UIImageView!
    @IBOutlet weak var newsPubDate: UILabel!
    @IBOutlet weak var titleOfNews: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var newsData: RSSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonDesign()
        addDataToViewController()
    }
    //Изменения дизайна кнопки
    func buttonDesign(){
        self.webButton.layer.cornerRadius = 10
        self.webButton.layer.shadowColor = UIColor.lightGray.cgColor
        self.webButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.webButton.layer.shadowRadius = 2.0
        self.webButton.layer.shadowOpacity = 1.0
        self.webButton.layer.masksToBounds = false;
        self.webButton.layer.shadowPath = UIBezierPath(roundedRect:self.webButton.bounds, cornerRadius:self.webButton.layer.cornerRadius).cgPath
    }
    //Добавление данных на ViewController
    func addDataToViewController(){
        titleOfNews.text = newsData?.title
        newsPubDate.text = newsData?.pubdate
        descriptionOfNews.text = newsData?.descriptionnews
        //Загрузка изображения на ViewController
        if self.newsData?.image != ""{
            self.networkSession.downloadData(siteAdress: (self.newsData?.image)!) { (data) in
                DispatchQueue.main.async {
                    if data.isEmpty == false {
                        self.process(UIImage(data: data)!)
                    }
                }
            }
        }
    }
    
    //Выбор изображения для определения лиц
    func process(_ image: UIImage) {
        imageOfNews.image = image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let request = VNDetectFaceRectanglesRequest { [unowned self] request, error in
            if let error = error {
                print(error)
            }
            else {
                self.handleFaces(with: request)
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    //Отслеживание и обозначение лиц на изображении
    func handleFaces(with request: VNRequest) {
        imageOfNews.layer.sublayers?.forEach { layer in
            layer.removeFromSuperlayer()
        }
        guard let observations = request.results as? [VNFaceObservation] else {
            return
        }
        observations.forEach { observation in
            let boundingBox = observation.boundingBox
            let size = CGSize(width: boundingBox.width * imageOfNews.bounds.width,
                              height: boundingBox.height * imageOfNews.bounds.height)
            let origin = CGPoint(x: boundingBox.minX * imageOfNews.bounds.width,
                                 y: (1 - observation.boundingBox.minY) * imageOfNews.bounds.height - size.height)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(origin: origin, size: size)
            
            imageOfNews.addSubview(blurEffectView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView"{
            let destinationVC = segue.destination as? DetailWebViewController
            destinationVC?.siteAdress = newsData?.guid
        }
    }
}

