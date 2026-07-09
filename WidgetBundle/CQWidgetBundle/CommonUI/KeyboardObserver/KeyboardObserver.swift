//
//  QuickStartUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/24.
//

import UIKit
import Combine

public class KeyboardObserver: ObservableObject {
    @Published public var keyboardHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}
