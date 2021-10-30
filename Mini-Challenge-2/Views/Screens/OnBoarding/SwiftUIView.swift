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
        
        ScrollView{
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
                                
                                print(minX)
                                
                                DispatchQueue.main.async {
                                    withAnimation(.default){
                                        self.offset = -minX
                                    }
                                }
                                return Color.clear
                            }
                                .frame(width: 0, height: 0)
                            , alignment: .leading
                        )
                        
                        
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
            //.tabViewStyle(PageTabViewStyle())
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear() {
                setupAppearance()
            }
            //Animated Indicators
            .overlay(
                CustomPageIndicatorWithContinueButton(
                    currentTab: currentTab,
                    index: index,
                    delegate: delegate)
                ,alignment: .bottom
            )
           
            

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
    
//    var body: some View {
//
//        ZStack {
//            GeometryReader { reader in
//                HStack(spacing: 0) {
//                    ForEach(OnboardingData.list) { item in
//                        OnboardingView(
//                            data: item
//                        )
//                            .frame(width: screenWidth)
//                    }
//                }
//                .offset(x: xOffset)
//                .gesture(
//                    DragGesture()
//                        .onChanged({ value in
//                            onChanged(value: value)
//                        })
//                        .onEnded({ value in
//                            onEnded(value: value)
//                        })
//                )
//            }
//
//            VStack() {
//                Spacer()
//
//                ZStack() {
//                    HStack(spacing: 6) {
//                        ForEach(0 ..< OnboardingData.list.count + 1) { i in
//                            Circle()
//                                .frame(width: 6, height: 6)
//                                .scaledToFit()
//                        }
//                    }
//                    .foregroundColor(.clear)
//                    VStack(spacing: -10) {
//                        HStack(spacing: 6) {
//                            ForEach(0 ..< OnboardingData.list.count) { i in
//                                if i == currentPage {
//                                    Capsule()
//                                        .matchedGeometryEffect(id: "page", in: namespace)
//                                        .frame(width: 18, height: 6)
////                                        .animation(.default)
//                                } else {
//                                    Circle()
//                                        .frame(width: 6, height: 6)
//                                }
//                            }
//
//                        }
//                    .foregroundColor(.white)
//                    }
//                }
//                .offset(y: -50)
//
//
//                    ZStack () {
//                        if currentPage != lastPage {
//                            HStack {
//                                Button(action: {
//                                    currentPage = lastPage
//                                    withAnimation {
//                                        xOffset = -screenWidth * CGFloat(currentPage)
//                                    }
//                                }, label: {
//                                    Text("Skip")
//                                        .frame(maxHeight: .infinity)
//                                })
//
//                                Spacer()
//
//                                Button(action: {
//                                    currentPage += 1
//                                    withAnimation {
//                                        xOffset = -screenWidth * CGFloat(currentPage)
//                                    }
//                                }, label: {
//                                    HStack {
//                                        Text("Next")
//
//                                        Image(systemName: "arrow.right")
//                                    }
//                                    .font(.system(size: 17, weight: .bold))
//                                    .frame(maxHeight: .infinity)
//                                })
//                            }
//                            .frame(height: 60)
//                            .foregroundColor(.white)
//
//                        } else {
//                            Button(action: {
////                                self.presented.toggle()
//                                self.delegate.finish()
//
//                            }, label: {
//                                    Text("CONTINUE")
//                                    .foregroundColor(.black)
//                                    .fontWeight(.semibold)
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 60)
//                                    .background(Capsule().fill(Color.white))
//
//                            })
//
//                        }
//                    }
//                    .offset(y: -20)
//                    .padding(.horizontal)
//            }
//        }
//
//        .background(Color(.white))
//    }
//
//    func onChanged(value: DragGesture.Value) {
//        xOffset = value.translation.width - (screenWidth * CGFloat(currentPage))
//    }
//
//    func onEnded(value: DragGesture.Value) {
//        if -value.translation.width >= screenWidth / 2  && currentPage < lastPage {
//            currentPage += 1
//        } else {
//            if value.translation.width >= screenWidth / 2 && currentPage > firstPage {
//                currentPage -= 1
//            }
//        }
//
//        withAnimation {
//            xOffset = -screenWidth * CGFloat(currentPage)
//        }
//    }
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
                       }
                            , label: {
                               Text("LET'S DO IT")
                               .foregroundColor(.black)
                               .fontWeight(.bold)
                               .frame(width: 220, height: 200, alignment: .center)
                               .frame(height: 60)
                               .background(Capsule().fill(Color.white))

                       })
                        .padding(.bottom, 25)
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
            }
            .padding(
                .bottom,
                UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .padding(.bottom, 20)
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

