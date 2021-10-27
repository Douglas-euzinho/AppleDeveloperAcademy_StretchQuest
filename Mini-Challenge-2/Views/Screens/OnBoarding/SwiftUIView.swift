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
    var firstPage = 0
    var index = 0
    
    @State var xOffset: CGFloat = 0
    @Namespace var namespace

    
    var body: some View {
       
        ZStack {
            GeometryReader { reader in
                HStack(spacing: 0) {
                    ForEach(OnboardingData.list) { item in
                        OnboardingView(
                            data: item
                        )
                            .frame(width: screenWidth)
                    }
                }
                .offset(x: xOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            onChanged(value: value)
                        })
                        .onEnded({ value in
                            onEnded(value: value)
                        })
                )
            }
            
            VStack() {
                Spacer()
                
                ZStack() {
                    HStack(spacing: 6) {
                        ForEach(0 ..< OnboardingData.list.count + 1) { i in
                            Circle()
                                .frame(width: 6, height: 6)
                                .scaledToFit()
                        }
                    }
                    .foregroundColor(.gray)
                    VStack(spacing: -10){
                        HStack(spacing: 6) {
                            ForEach(0 ..< OnboardingData.list.count) { i in
                                if i == currentPage {
                                    Capsule()
                                        .matchedGeometryEffect(id: "page", in: namespace)
                                        .frame(width: 18, height: 6)
                                        .animation(.default)
                                } else {
                                    Circle()
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                    .foregroundColor(.gray)
                    }
                }
                
                    ZStack () {
                        if currentPage != lastPage {
                            HStack {
                                Button(action: {
                                    currentPage = lastPage
                                    withAnimation {
                                        xOffset = -screenWidth * CGFloat(currentPage)
                                    }
                                }, label: {
                                    Text("Skip")
                                        .frame(maxHeight: .infinity)
                                })
                                
                                Spacer()
                                
                                Button(action: {
                                    currentPage += 1
                                    withAnimation {
                                        xOffset = -screenWidth * CGFloat(currentPage)
                                    }
                                }, label: {
                                    HStack {
                                        Text("Next")
                                                
                                        Image(systemName: "arrow.right")
                                    }
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxHeight: .infinity)
                                })
                            }
                            .frame(height: 60)
                            .foregroundColor(.white)
                            
                        } else {
                            Button(action: {
//                                self.presented.toggle()
                                self.delegate.finish()
                                
                            }, label: {
                                    Text("GET STARTED!")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .frame(width: 160, height: 60)
                                        .background((Color.green))
                                        .cornerRadius(20)
                                
                            })

                        }
                    }
                    .padding(.bottom)
            }
        }

        .background(Color(.white))
    }
    
    func onChanged(value: DragGesture.Value) {
        xOffset = value.translation.width - (screenWidth * CGFloat(currentPage))
    }
    
    func onEnded(value: DragGesture.Value) {
        if -value.translation.width > screenWidth / 2  && currentPage < lastPage {
            currentPage += 1
        } else {
            if value.translation.width > screenWidth / 2 && currentPage > firstPage {
                currentPage -= 1
            }
        }
        
        withAnimation {
            xOffset = -screenWidth * CGFloat(currentPage)
        }
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(delegate: OnboardDismissDelegate())
    }
}

