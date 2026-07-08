//
//  CQControlWidgetEntityCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SnapKit
import CJCollectionViewLayout_Swift
import CQWidgetBundle // 需要使用 CJHostingView
import CQWidgetBundleCommon

class CQControlWidgetGroupCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var collectionView: ControlWidgetGroupCollectionView!
    var onTapSelf: (() -> Void)?
    var onTapGroupItem: ((_ groupItemModel: BaseControlWidgetEntity) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let titleLabel = UILabel()
        //titleLabel.backgroundColor = UIColor.green
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(12)
        }
        self.titleLabel = titleLabel
        
        
        let collectionView = ControlWidgetGroupCollectionView.init(frame: .zero, onTapSelf: { [weak self] in
            self?.onTapSelf?()
        }, onTapEntity: { [weak self] groupItemModel in
            self?.onTapGroupItem?(groupItemModel)
        })
        collectionView.backgroundColor = UIColor(hex: "#F8F8F8")
        collectionView.layer.cornerRadius = 22.5
        collectionView.layer.masksToBounds = true
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-7.5)
        }
        self.collectionView = collectionView
    }
    
    func configure(tapSelfHandler: @escaping () -> Void, tapGroupItemHandler: @escaping (_ groupItemModel: BaseControlWidgetEntity) -> Void) {
        self.onTapSelf = tapSelfHandler
        self.onTapGroupItem = tapGroupItemHandler
    }
    
    func setModel(_ setModel: BaseControlWidgetSetModel) {
        self.titleLabel.text = setModel.name
        
        self.collectionView.groupItemModels = setModel.entitys
        self.collectionView.reloadData()
    }
}

@objc public class ControlWidgetGroupCollectionView: UICollectionView {
    var groupItemModels: [BaseControlWidgetEntity] = []
    var onTapSelf: (() -> Void)
    var onTapEntity: ((_ groupItemModel: BaseControlWidgetEntity) -> Void)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 初始化方法
    public init(frame: CGRect,
                      onTapSelf: @escaping () -> Void,
         onTapEntity: @escaping (_ groupItemModel: BaseControlWidgetEntity) -> Void)
    {
        self.onTapSelf = onTapSelf
        self.onTapEntity = onTapEntity
        
        let layout = CJLeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // 注册 Cell 类型
        register(ControlWidgetGroupItemCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ControlWidgetGroupItemCollectionViewCell.self))
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
        
        // 添加点击手势识别器来监听 collectionView 外的点击事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideCollectionView(_:)))
        tapGesture.cancelsTouchesInView = false // 确保手势识别器不会阻止其他视图的事件传递
        self.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(forName: Notification.Name("kNoti_Get_NewSymbols"), object: nil, queue: .main) { _ in
            self.reloadData()
        }
    }
    

    @objc func handleTapOutsideCollectionView(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        if let indexPath = self.indexPathForItem(at: touchPoint) {
            return
        } else {
            self.onTapSelf()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ControlWidgetGroupCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupItemModel = groupItemModels[indexPath.row]
        onTapEntity(groupItemModel)
    }
}

// MARK: - UICollectionViewDataSource
extension ControlWidgetGroupCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupItemModels.count // 假设有 20 个数据项
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupItemModel = groupItemModels[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ControlWidgetGroupItemCollectionViewCell.self), for: indexPath) as! ControlWidgetGroupItemCollectionViewCell
        //cell.backgroundColor = .cyan
        cell.setGroupItemModel(groupItemModel)
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ControlWidgetGroupCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupItemModel = groupItemModels[indexPath.row]

        var columnCount: Int
        var topWidthHeightRatio: CGFloat // 除文字和间距外的顶部视图的宽高比
        var imageDistanceAndImageHeight: CGFloat
  
        columnCount = 4
        topWidthHeightRatio = 70.0/70.0
        imageDistanceAndImageHeight = 0
           

        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let columnSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let collectionWidth = collectionView.frame.size.width //UIScreen.main.bounds.width
        let itemsWithSpacingWidth = collectionWidth - sectionInset.left - sectionInset.right
        let itemsWidth = itemsWithSpacingWidth - columnSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor(itemsWidth / CGFloat(columnCount))
        let itemTopHeight = floor(itemWidth / topWidthHeightRatio)
        let itemHeight = itemTopHeight + imageDistanceAndImageHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


/// Group 中 item 的 cell
class ControlWidgetGroupItemCollectionViewCell: UICollectionViewCell {
    var preImageView: CJHostingView<BaseControlWidgetViewInApp>! // 预览图（整个结构使用预览图展示）
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let preImageView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
        self.contentView.addSubview(preImageView)
        preImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.preImageView = preImageView
    }
    
    func setGroupItemModel(_ groupItemModel: BaseControlWidgetEntity) {
//        self.preImageView.layer.borderWidth = 0.5
//        self.preImageView.layer.borderColor = UIColor(hex: "#F0F0F0").cgColor
//        if groupItemModel.style == .circle {
            self.preImageView.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0
//        } else {
//            self.preImageView.layer.cornerRadius = 15
//        }
        
        self.preImageView.configure(with: BaseControlWidgetViewInApp(entity: groupItemModel, pageInfo: CCPageInfo(pageType: .homePage)))
    }
}



class CQControlWidgetSetCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var widgetView: CJHostingView<BaseControlWidgetViewInApp>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let titleLabel = UILabel()
        //titleLabel.backgroundColor = UIColor.green
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        self.titleLabel = titleLabel
        
        
        let widgetView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
        widgetView.backgroundColor = UIColor(hex: "#C7C7C7")
        widgetView.layer.cornerRadius = 22.5
        self.contentView.addSubview(widgetView)
        widgetView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        self.widgetView = widgetView
    }
    
    func setModel(_ setModel: BaseControlWidgetSetModel) {
        self.titleLabel.text = setModel.name
        return
        
        let entitys = setModel.entitys
        if entitys.count > 0 {
            let setviews = WidgetSetView(frame: bounds, setModel: setModel)
            self.widgetView.addSubview(setviews)
            setviews.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            let entity: BaseControlWidgetEntity = setModel.entitys[0]
            self.widgetView.configure(with: BaseControlWidgetViewInApp(entity: entity, pageInfo: CCPageInfo(pageType: .homePage)))
        }
    }
}

class WidgetSetView: UIView {
    var setModel: BaseControlWidgetSetModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, setModel: BaseControlWidgetSetModel) {
        self.setModel = setModel
        super.init(frame: frame)
//        setupViews()
        
        let entitys = setModel.entitys
        var views: [UIView] = []
        for (index, entity) in entitys.enumerated() {
            let view = BaseControlWidgetViewInApp(entity: entity, pageInfo: CCPageInfo(pageType: .homePage))
            let widgetView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
            widgetView.configure(with: view)
            views.append(widgetView)
        }
        let fixedWidth = 70.0
        let setviews = HorizontalContainerView(mysubviews: views, fixedWidth: fixedWidth)
        self.addSubview(setviews)
        setviews.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupViews() {
        
    }
}


class HorizontalContainerView: UIView {
    private var mysubviews: [UIView]
    private let fixedWidth: CGFloat
    
    // 初始化方法
    init(mysubviews: [UIView], fixedWidth: CGFloat) {
        self.mysubviews = mysubviews
        self.fixedWidth = fixedWidth
        super.init(frame: .zero)
        
        // 添加子视图
        for view in mysubviews {
            addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重写 layoutSubviews 方法
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 调用布局方法
        customLayoutSubviews()
    }
    
    // 布局方法
    private func customLayoutSubviews() {
        // 清除之前的约束
        mysubviews.forEach { $0.snp.removeConstraints() }
        
        // 计算总宽度（所有视图的宽度总和）
        let totalWidth = fixedWidth * CGFloat(mysubviews.count)
        
        // 计算总间距（容器宽度 - 总宽度）
        let totalSpacing = bounds.width - totalWidth
        
        // 计算每个间距（总间距 / (视图数量 - 1)）
        let spacing = totalSpacing / CGFloat(max(mysubviews.count - 1, 1))
        
        // 遍历视图并设置约束
        for (index, view) in mysubviews.enumerated() {
            view.snp.makeConstraints { make in
                make.width.equalTo(fixedWidth) // 固定宽度
                make.top.bottom.equalToSuperview() // 垂直方向填充容器
                
                if index == 0 { // 第一个视图的起始约束
                    make.leading.equalToSuperview()
                } else {        // 后续视图的起始约束，加上间距
                    make.leading.equalTo(mysubviews[index - 1].snp.trailing).offset(spacing)
                }
                
                if index == mysubviews.count - 1 {  // 最后一个视图的结束约束
                    make.trailing.equalToSuperview()
                }
            }
        }
    }
    
    
}
