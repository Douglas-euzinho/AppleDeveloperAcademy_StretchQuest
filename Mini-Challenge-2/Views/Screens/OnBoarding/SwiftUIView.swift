//
//  SwiftUIView.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//
import SwiftUI

struct ContentView: View {
    @State private var showOnBoarding = true
    @State private var currentTab = 0
    
    var body: some View {
        
        TabView(selection: $currentTab, content:  {
            ForEach(OnboardingData.list) { viewData in
                OnboardingView(data: viewData, page: currentTab).tag(viewData.id)
            }
        })
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
