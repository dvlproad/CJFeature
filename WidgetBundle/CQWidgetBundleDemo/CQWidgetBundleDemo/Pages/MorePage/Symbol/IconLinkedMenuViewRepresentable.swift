//
//  IconLinkedMenuViewRepresentable.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/11.
//

import SwiftUI
import CJListKit_Swift
import CQWidgetBundleCommon

public struct IconLinkedMenuViewRepresentable: UIViewRepresentable {
    var rightColumnCount: Int
    var layoutModel: CJLinkedMenuLayoutModel
    @Binding var isForCloseState: Bool
    var alwaysDisableTintColor: Bool
    var selectedImageName: String
    var onTapRightIndexPath: ((IndexPath, _ newImageModel: CJBaseImageModel) -> Void)
    var requestDataHandler: ((@escaping ([IconLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)?
    
    public func makeUIView(context: Context) -> IconLinkedMenuView {
        // Initialize the custom view and return it
        return IconLinkedMenuView(
            rightColumnCount: rightColumnCount,
            layoutModel: layoutModel,
            isForCloseState: isForCloseState,
            alwaysDisableTintColor: alwaysDisableTintColor,
            selectedImageName: selectedImageName,
            onTapRightIndexPath: onTapRightIndexPath,
            requestDataHandler: requestDataHandler
        )
    }
    
    public func updateUIView(_ uiView: IconLinkedMenuView, context: Context) {
        // Here, you can update the view if needed (e.g., if any state changes)
        uiView.isForCloseState = isForCloseState
    }
}
