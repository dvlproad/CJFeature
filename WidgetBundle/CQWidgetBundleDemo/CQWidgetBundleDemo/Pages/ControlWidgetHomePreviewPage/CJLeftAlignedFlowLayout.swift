//
//  CJLeftAlignedFlowLayout.swift
//  CJListKit-Swift
//
//  Created by qian on 2025/1/17.
//
//  当 collectionView 中cell的宽度不同的时候，一个原本可显示4个cell的某行，当cell只有两个的时候，其排列位置会变成1和4,而不是1和2

import UIKit

@objc public class CJLeftAlignedFlowLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return nil }
        
        // 通过 delegate 获取 sectionInset
        let sectionInset = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView, layout: self, insetForSectionAt: 0) ?? self.sectionInset
        
        // 通过 delegate 获取 minimumInteritemSpacing
        let minimumInteritemSpacing = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: 0) ?? self.minimumInteritemSpacing
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for attr in attributes {
            if attr.representedElementCategory != .cell { continue }
            
            // 如果是新的一行，重置左边距
            if attr.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            // 调整 cell 的 X 坐标，使其左对齐
            attr.frame.origin.x = leftMargin
            
            // 更新 leftMargin
            leftMargin += attr.frame.width + minimumInteritemSpacing
            maxY = max(attr.frame.maxY, maxY)
        }
        
        return attributes
    }
}
