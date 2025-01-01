//
//  ContentView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TSAdsPage()) {
                    Text("TSAdsPage")
                }
            }
        }.onAppear() {
            CJAdsManager.BUAdSDKReset()
        }
    }
}

#Preview {
    ContentView()
}
