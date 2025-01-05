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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        for i in 0...9 {
            dataModels.append(TSDataModel())
        }
        
        widthAdCollectionView = WidthAdCollectionView(frame: view.bounds, collectionViewLayout: layout)
        widthAdCollectionView.dataModels = dataModels
        view.addSubview(widthAdCollectionView)
    }
}


