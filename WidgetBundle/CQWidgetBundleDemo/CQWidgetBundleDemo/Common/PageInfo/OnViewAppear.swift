//
//  OnViewAppear.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/19.
//

import SwiftUI

extension View {
    func cj_onAppear(viewDidLoad: @escaping (() -> Void),
                     viewDidAppear: @escaping (() -> Void)
    ) -> some View {
        modifier(CJOnAppear(viewDidLoad: viewDidLoad, viewDidAppear: viewDidAppear))
    }
}

private struct CJOnAppear: ViewModifier {
    let viewDidLoad: (() -> Void)
    let viewDidAppear: (() -> Void)
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                viewDidLoad()
            } else {
                viewDidAppear()
            }
        }
    }
}

