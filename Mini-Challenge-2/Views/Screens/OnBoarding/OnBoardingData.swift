//
//  OnBoardingData.swift
//  Mini-Challenge-2
//
//  Created by Daniel Gomes Ribeiro on 04/10/21.
//

import SwiftUI

struct OnboardingData: Hashable, Identifiable {
    let id: Int
    let background: [Color]
    let imagePath: String
    let primaryText: String
    let secondaryText: String
    
    static let defaultBackground  = [Color(#colorLiteral(red: 0.4520270228, green: 0.6316480041, blue: 0.8997491002, alpha: 1)), Color(#colorLiteral(red: 0.4462057352, green: 0.6318677664, blue: 0.8956100345, alpha: 1))]
    static let defaultBackground2 = [Color(#colorLiteral(red: 0.3294117647, green: 0.6784313725, blue: 0.5764705882, alpha: 1)), Color(#colorLiteral(red: 0.330360204, green: 0.6797993183, blue: 0.5749633312, alpha: 1))]
    static let defaultBackground3 = [Color(#colorLiteral(red: 0.8947000504, green: 0.451097548, blue: 0.4500651956, alpha: 1)), Color(#colorLiteral(red: 0.8947000504, green: 0.451097548, blue: 0.4500651956, alpha: 1))]


    
    static let list: [OnboardingData] = [
        OnboardingData(id: 0, background: defaultBackground, imagePath: "", primaryText: "Welcome", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle"),
        OnboardingData(id: 1, background: defaultBackground2, imagePath: "", primaryText: "Attributes", secondaryText: "Increase your strength, flexibility or posture attributes with each stretching you perform"),
        OnboardingData(id: 2, background: defaultBackground3, imagePath: "", primaryText: "Profile", secondaryText: "As the stretchings are completed, you will get healthier and willing to confront your daily challenges.")
    ]
}

struct OnboardingView: View {
    
    var data: OnboardingData
    @ObservedObject var delegate: OnboardDismissDelegate
    var index: Int
    var body: some View {
        
        VStack(spacing: 20) {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [data.background[0], data.background[1]]),startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()

                VStack(alignment: .center, spacing: 10, content: {

                    Image(data.imagePath)
                    //    .resizable()
                        .scaledToFit()

                    Text(data.primaryText)
                        .bold().font(.largeTitle)
                        .font(.system(size: 30, weight: .bold))

                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                        .animation(Animation.interpolatingSpring(stiffness: 60, damping: 10))


                    Text(data.secondaryText)
                        .bold()
                        .font(.system(size: 25, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                        .animation(Animation.interpolatingSpring(stiffness: 60, damping: 10))

                    Spacer()
                        .frame(height: 60)
                    
                    if index == OnboardingData.list.count-1 {
                        Button(action: {
                       // self.presented.toggle()
                               self.delegate.finish()
                           }
                                , label: {
                                   Text("CONTINUE")
                                   .foregroundColor(.black)
                                   .fontWeight(.bold)
                                   .frame(width: 200, height: 200, alignment: .center)
                                   .frame(height: 60)
                                   .background(Capsule().fill(Color.white))

                           })
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: -1, y: 5)
                            .shadow(color: Color.black.opacity(0.2), radius: -3, x: -1, y: -5)
                            .offset(y: 100)
                    }

                })
                    .ignoresSafeArea()
            }

        }

    }
}

