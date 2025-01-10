//
//  ContentView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import SwiftUI

struct ContentView: View {
    let adManager = AdManager()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TSAdsPage()) {
                    Text("TSAdsPage2")
                }
                
                NavigationLink(destination: TSAdsHomePage()) {
                    Text("TSAdsHomePage")
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
