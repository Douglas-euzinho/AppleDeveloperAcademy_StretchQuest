//
//  SwiftUIView.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import SwiftUI

class OnboardDismissDelegate: ObservableObject {
    
    var onDismiss: () -> () = {}
    
    func finish() {
        self.onDismiss()
    }
}


struct ContentView: View {
    
    @State private var showOnBoarding = true
    @State private var currentPage = 0
    @State private var presented = false
    
    @ObservedObject var delegate: OnboardDismissDelegate

    var screenWidth = UIScreen.main.bounds.width
    var lastPage = OnboardingData.list.count - 1
    @State private var currentTab = 0

    var firstPage = 0
    @State var index = 0
    
    @State var xOffset: CGFloat = 0
    @Namespace var namespace
    
    @State var offset: CGFloat = 0

    var body: some View {
        
        ScrollView(.horizontal) {
            TabView(selection: $currentTab, content:  {
                ForEach(OnboardingData.list) { viewData in
                    
                    if viewData.id == 0 {
                    
                        OnboardingView(
                            data: viewData,
                            delegate: delegate,
                            index: viewData.id)
                        .tag(viewData.id)
                        .overlay(
                        
                            GeometryReader { proxy -> Color in
                                let minX = proxy.frame(in: .local).minX
                                
                                DispatchQueue.main.async {
                                    withAnimation(.default){
                                        self.offset = -minX
                                    }
                                }
                                return Color.clear
                            }.frame(width: 0, height: 0), alignment: .leading)
                        
                    } else {
                        
                        OnboardingView(
                            data: viewData,
                            delegate: delegate,
                            index: viewData.id)
                            .tag(viewData.id)
                        
                    }
                }
            })
            .frame(width: screenWidth, height: UIScreen.main.bounds.height)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear() {
                setupAppearance()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func getIndicatorXOffset() -> CGFloat {
        22 * (offset / getWidth())
    }
    
    func getIndex() -> Int {
        Int(round(Double(offset / getWidth())))
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .white
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}


struct CustomPageIndicatorWithContinueButton: View {
    
    var currentTab: Int
    var index: Int
    
    @ObservedObject var delegate: OnboardDismissDelegate

    @State var scale: CGFloat = 0
    
    var body: some View {
        VStack {
            
            if currentTab == 2 {
                Button(action: {
                    self.delegate.finish()
                }, label: {
                    Text("LET'S DO IT")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(width: 220, height: 60, alignment: .center)
                        .background(Capsule().fill(Color.white))
                })
                    .padding()
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: -1, y: 5)
                    .transition(.slide)
            }
            
            HStack(spacing: 15) {
                
                ForEach(0...2, id: \.self) { index in
                    Capsule()
                        .fill(Color.white)
                        .frame(
                            width: currentTab == index ? 20 : 7,
                            height: 7)
                }
            }.padding()
        }
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(delegate: OnboardDismissDelegate())
            .previewDevice("iPhone 8")
    }
}

extension View {
    
    func getWidth() -> CGFloat {
        UIScreen.main.bounds.width
    }
    
}

