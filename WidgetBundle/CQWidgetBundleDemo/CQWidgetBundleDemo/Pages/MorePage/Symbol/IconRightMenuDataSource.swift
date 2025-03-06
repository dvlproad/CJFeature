//
//  IconRightMenuDataSource.swift
//  CJListDemo-Swift
//
//  Created by qian on 2025/2/11.
//

import UIKit
import SnapKit

class IconRightMenuDataSource: NSObject, UICollectionViewDataSource {
    
    public var sectionDataModels: [IconLinkMenuSectionModel]
    public var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    
    private var cellAtIndexPathConfigBlock: ((UICollectionViewCell, IndexPath) -> Void)?
    
    // MARK: - Init
    /*
     *  初始化 CollectionView 的 dataSource
     *
     *  @param sectionDataModels            每个section的数据(section中的数据元素必须是 CQDMModuleModel )
     *  @param enableTintColor              是否显示tintColor，控制中心图标关闭状态时候不显示
     *
     *  @return CollectionView 的 dataSource
     */
    init(sectionDataModels: [IconLinkMenuSectionModel], enableTintColor: Bool) {
        self.sectionDataModels = sectionDataModels
        self.enableTintColor = enableTintColor
        super.init()
    }
    
    /*
     *  注册 CollectionView 所需的所有 cell
     */
    func registerAllCells(for collectionView: UICollectionView) {
        collectionView.register(RightMenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    /*
     *  获取指定位置的dataModel
     *
     *  @return 指定位置的dataModel
     */
    func dataModel(at indexPath: IndexPath) -> CJBaseImageModel {
        let sectionDataModel = sectionDataModels[indexPath.section]
        let dataModels = sectionDataModel.values
        return dataModels[indexPath.row] 
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionDataModel = sectionDataModels[section]
        return sectionDataModel.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let moduleModel = dataModel(at: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RightMenuCollectionViewCell
        cell.imageView.image = moduleModel.createUIImage()
        if enableTintColor, let tintColorString = moduleModel.imageColorString {
            cell.imageView.tintColor = UIColor(hex: tintColorString)
        } else {
            cell.imageView.tintColor = UIColor.black
        }
        
        cell.textLabel.text = moduleModel.name
        
        return cell
    }
}


class RightMenuCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12.0
        isSelected = false
        
        let parentView = contentView
        parentView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        
        // ImageView setup
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        parentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(parentView)
            make.left.equalTo(parentView).offset(0)
            make.top.equalTo(parentView).offset(0)
        }
        
        // TextLabel setup
        textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = UIColor(hex: "#333333", alpha: 1.0)
        parentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(parentView)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            let parentView = contentView
            parentView.layer.masksToBounds = true
            if isSelected {
                parentView.layer.borderColor = UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1.0).cgColor
                parentView.layer.borderWidth = 1.5
            } else {
                parentView.layer.borderColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0).cgColor
                parentView.layer.borderWidth = 1.5
            }
        }
    }
}

