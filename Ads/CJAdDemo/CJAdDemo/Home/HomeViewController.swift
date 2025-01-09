//
//  HomeCollectionView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/5.
//


import UIKit
import SwiftUI

struct WidthAdCollectionViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = HomeViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 更新 UI 的逻辑（如果需要）
    }
}


class HomeViewController: UIViewController {
    var widthAdCollectionView: WidthAdCollectionView!
    
    var dataModels: [TSDataModel] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        var adIndex = 0
        for i in 0...999 {
            var model: TSDataModel
            if i % 2 == 1 {
                model = TSDataModel(adIndex: adIndex)
                adIndex += 1
            } else {
                model = TSDataModel(title: "这是\(adIndex)")
            }
            dataModels.append(model)
        }
        
        widthAdCollectionView = WidthAdCollectionView(frame: view.bounds, collectionViewLayout: layout, adRootViewController: self)
        widthAdCollectionView.dataModels = dataModels
        widthAdCollectionView.insertAd(adId: "103320730", adRootViewController: self)
        view.addSubview(widthAdCollectionView)
    }
}


