//
//  CJLinkedCollectionMenuView.swift
//  CJListKit-Swift
//
//  Created by qian on 2025/1/17.
//

import UIKit

@objc public class CJLinkedMenuLayoutModel: NSObject {
    var sectionInset: UIEdgeInsets
    var rightHeaderHeight: CGFloat
    var rightCellWidthHeightRatio: CGFloat = 1.0    // 右侧列表单元的宽高比
    var minimumLineSpacing: CGFloat = 17.0
    var minimumInteritemSpacing: CGFloat = 17.0
    
    @objc public init(
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        rightHeaderHeight: CGFloat,
        rightCellWidthHeightRatio: CGFloat,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat
    ) {
        self.sectionInset = sectionInset
        self.rightHeaderHeight = rightHeaderHeight
        self.rightCellWidthHeightRatio = rightCellWidthHeightRatio
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
}

@objc public class CJLinkedCollectionMenuView: UIView, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private(set) var leftTableView: UITableView!
    private(set) var rightCollectionView: UICollectionView!
    
    private var click: Bool = false
    
    private var leftWidth: CGFloat
    private var rightColumnCount: Int
    
    // cell 的高度
    private var leftCellHeight: CGFloat
    private var layoutModel: CJLinkedMenuLayoutModel
    
    private weak var leftDataSource: UITableViewDataSource?
    private weak var rightDataSource: UICollectionViewDataSource?
    
    private var leftTableViewSetupBlock: ((UITableView) -> Void)?
    private var rightCollectionViewSetupBlock: ((UICollectionView) -> Void)?
    private var onTapRightIndexPath: ((IndexPath) -> Void)?
    
    /*
     *  初始化"联动菜单"的 dataSource
     *
     *  @param leftWidth                    左侧菜单所占宽度
     *  @param rightColumnCount             右侧菜单列数
     *  @param leftCellHeight               左侧列表单元的高度
     *  @param layoutModel                  布局(右侧列表单元的宽高比)
     *  @param leftSetupBlock               左侧菜单的setupBlock
     *  @param leftDataSource               左侧菜单的dataSource
     *  @param rightSetupBlock              右侧菜单的setupBlock
     *  @param rightDataSource              右侧菜单的dataSource
     *  @param onTapRightIndexPath          点击右侧的数据
     *
     *  @return CollectionView 的 dataSource
     */
    @objc public init(leftWidth: CGFloat,
                      rightColumnCount: Int,
                      leftCellHeight: CGFloat,
                      layoutModel: CJLinkedMenuLayoutModel,
                      leftSetupBlock: ((UITableView) -> Void)?,
                      leftDataSource: UITableViewDataSource?,
                      rightSetupBlock: @escaping (UICollectionView) -> Void,
                      rightDataSource: UICollectionViewDataSource?,
                      onTapRightIndexPath: @escaping (IndexPath) -> Void)
    {
        self.leftWidth = leftWidth
        self.rightColumnCount = rightColumnCount
        self.leftCellHeight = leftCellHeight
        self.layoutModel = layoutModel
        
        self.leftDataSource = leftDataSource
        self.rightDataSource = rightDataSource
        self.leftTableViewSetupBlock = leftSetupBlock
        self.rightCollectionViewSetupBlock = rightSetupBlock
        self.onTapRightIndexPath = onTapRightIndexPath
        
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func reloadData() {
        leftTableView.reloadData()
        rightCollectionView.reloadData()
    }
    
    /**
     * @abstract 更新选中哪些位置(一般在 layoutSubviews 或 viewDidLayoutSubviews 中调用以设置初始选中的cell）
     *
     * @param selectedIndexPaths   选中的indexPath数组
     * @param animated                    是否需要滚动滚动
     * @param scrollPosition              scrollPosition
     */
    @objc public func updateSelectedIndexPaths(_ selectedIndexPaths: [IndexPath]?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        selectedIndexPaths?.forEach { indexPath in
            if !rightCollectionView.indexPathsForVisibleItems.contains(indexPath) {
                leftTableView.selectRow(at: IndexPath(row: indexPath.section, section: 0), animated: animated, scrollPosition: .none)
            }
            rightCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    /// 未有任何选中时候，左侧菜单默认选中第几个
    @objc public func leftSelectedRowIndex(row: Int, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        leftTableView.selectRow(at: IndexPath(row: row, section: 0), animated: animated, scrollPosition: scrollPosition)
    }
    
    private func setupViews() {
        click = false
        
        leftTableView = UITableView(frame: .zero, style: .plain)
        leftTableView.separatorStyle = .none    // 去掉 UITableViewCell 的分隔线（下划线）
        leftTableViewSetupBlock?(leftTableView)
        leftTableView.delegate = self
        leftTableView.dataSource = leftDataSource
        addSubview(leftTableView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        rightCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //rightCollectionView.bounces = true
        rightCollectionViewSetupBlock?(rightCollectionView)
        rightCollectionView.delegate = self
        rightCollectionView.dataSource = rightDataSource
        addSubview(rightCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        leftTableView.translatesAutoresizingMaskIntoConstraints = false
        rightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftTableView.topAnchor.constraint(equalTo: topAnchor),
            leftTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: leftWidth),
            
            rightCollectionView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor),
            rightCollectionView.topAnchor.constraint(equalTo: topAnchor),
            rightCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            let moveToIndexPath = IndexPath(row: 0, section: indexPath.row)
            click = true
            rightCollectionView.scrollToItem(at: moveToIndexPath, at: .top, animated: true)
            rightCollectionView.deselectItem(at: moveToIndexPath, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.leftCellHeight
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapRightIndexPath?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //print("=======取消选择")
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return layoutModel.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: layoutModel.rightHeaderHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layoutModel.minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return layoutModel.minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let perRowMaxColumnCount = rightColumnCount
        
        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let columnSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        
        let width = collectionView.frame.width
        let validWidth = width - sectionInset.left - sectionInset.right - columnSpacing * CGFloat(perRowMaxColumnCount - 1)
        let collectionViewCellWidth = floor(validWidth / CGFloat(perRowMaxColumnCount))
        
        let collectionViewCellHeight = collectionViewCellWidth / self.layoutModel.rightCellWidthHeightRatio
        
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellHeight)
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != leftTableView, !click else { return }
        
        let visibleIndexPaths = rightCollectionView.indexPathsForVisibleItems.sorted { $0.section < $1.section }
        guard let topVisibleIndexPath = visibleIndexPaths.first else { return }
        
        let moveToIndexPath = IndexPath(row: topVisibleIndexPath.section, section: 0)
        leftTableView.selectRow(at: moveToIndexPath, animated: true, scrollPosition: .middle)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView != leftTableView {
            click = false
        }
    }
}
