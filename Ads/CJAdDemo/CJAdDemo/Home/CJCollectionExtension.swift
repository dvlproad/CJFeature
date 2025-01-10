//
//  CJCollectionExtension.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/9.
//

import UIKit

extension UICollectionView {
    func reloadItems(at indexPaths: [IndexPath], completion: (() -> Void)? = nil) {
        // 使用 CATransaction 监听动画完成
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        self.reloadItems(at: indexPaths)
        CATransaction.commit()
    }
}



private var updatingIndexPathsKey: UInt8 = 0
extension UICollectionView {
    var updatingIndexPaths: Set<IndexPath> {
        get {
            // 获取关联对象
            return objc_getAssociatedObject(self, &updatingIndexPathsKey) as? Set<IndexPath> ?? []
        }
        set {
            // 设置关联对象
            objc_setAssociatedObject(self, &updatingIndexPathsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func reloadItemsSafely(at indexPaths: [IndexPath]) {
        // 过滤掉正在更新的 indexPaths
        let newUpdates = indexPaths.filter { !updatingIndexPaths.contains($0) }
        guard !newUpdates.isEmpty else { return }
        
        updatingIndexPaths.formUnion(newUpdates)
        reloadItems(at: newUpdates) {
            // 更新完成，清理记录
            self.updatingIndexPaths.subtract(newUpdates)
        }
    }
}


// 定义关联对象的key
private var pendingUpdatesKey: UInt8 = 0
private var isUpdatingKey: UInt8 = 0
extension UICollectionView {
    // 添加 pendingUpdates 属性
    var pendingUpdates: [IndexPath] {
        get {
            return objc_getAssociatedObject(self, &pendingUpdatesKey) as? [IndexPath] ?? []
        }
        set {
            objc_setAssociatedObject(self, &pendingUpdatesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 添加 isUpdating 属性
    var isUpdating: Bool {
        get {
            return objc_getAssociatedObject(self, &isUpdatingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &isUpdatingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func queueReloadItems(at indexPaths: [IndexPath]) {
        // 添加到待处理队列
        pendingUpdates.append(contentsOf: indexPaths)
        processPendingUpdates()
    }

    func cancelPendingUpdates() {
        // 清空队列
        pendingUpdates.removeAll()
    }

    private func processPendingUpdates() {
        // 如果正在更新，则跳过，等待完成后再处理
        guard !isUpdating, !pendingUpdates.isEmpty else { return }
        
        isUpdating = true
        let updates = pendingUpdates
        pendingUpdates.removeAll() // 清空队列，避免重复
        
        reloadItems(at: updates) { [weak self] in
            guard let self = self else { return }
            // 更新完成，继续处理队列
            self.isUpdating = false
            self.processPendingUpdates()
        }
    }
}



