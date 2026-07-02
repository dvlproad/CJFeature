//
//  TextLinkedMenuViewRepresentable.swift
//  WidgetIsland
//
//  Created by qian on 2025/2/11.
//

import SwiftUI

public struct TextLinkedMenuViewRepresentable: UIViewRepresentable {
    var rightColumnCount: Int
    var layoutModel: CJLinkedMenuLayoutModel
    @Binding var isForCloseState: Bool
    var selectedText: String
    var onTapRightIndexPath: ((IndexPath, _ newTextModel: TextLinkMenuDataModel) -> Void)
    var requestDataHandler: ((@escaping ([TextLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)?
    
    public func makeUIView(context: Context) -> TextLinkedMenuView {
        // Initialize the custom view and return it
        return TextLinkedMenuView(
            rightColumnCount: rightColumnCount,
            layoutModel: layoutModel,
            isForCloseState: isForCloseState,
            selectedText: selectedText,
            onTapRightIndexPath: onTapRightIndexPath,
            requestDataHandler: requestDataHandler
        )
    }
    
    public func updateUIView(_ uiView: TextLinkedMenuView, context: Context) {
        // Here, you can update the view if needed (e.g., if any state changes)
        uiView.isForCloseState = isForCloseState
    }
}
