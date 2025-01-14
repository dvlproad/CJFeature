//
//  CQControlWidgetHomeViewController.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit

class CQControlWidgetHomeViewController: UIViewController {
    var collectionView: CQControlWidgetCollectionView!
    
    var dataModels: [BaseControlWidgetEntity] = []
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)
    
    init(onTapEntity: @escaping (BaseControlWidgetEntity) -> Void) {
        self.onTapEntity = onTapEntity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupCollectionView()
        
        dataModels = CQControlWidgetIds.examples()
        self.collectionView.dataModels = dataModels
    }
    
    func setupCollectionView() {
        collectionView = CQControlWidgetCollectionView(frame: .zero, onTapEntity: onTapEntity)
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
