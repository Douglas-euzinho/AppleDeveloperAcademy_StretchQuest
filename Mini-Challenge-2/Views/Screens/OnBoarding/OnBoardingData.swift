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
    
    static let defaultBackground = [Color(#colorLiteral(red: 0.3294117647, green: 0.6784313725, blue: 0.5764705882, alpha: 1)), Color(#colorLiteral(red: 0.1259427965, green: 0.6884986758, blue: 0.5710187554, alpha: 1))]
    
    static let list: [OnboardingData] = [
        OnboardingData(id: 0, background: defaultBackground, imagePath: "", primaryText: "Welcome", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle"),
        OnboardingData(id: 1, background: defaultBackground, imagePath: "", primaryText: "Attributes", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle"),
        OnboardingData(id: 2, background: defaultBackground, imagePath: "", primaryText: "Status", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle")
    ]

}

struct OnboardingView: View {
    
    var data: OnboardingData

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
//                        .animation(Animation.interpolatingSpring(stiffness: 100, damping: 10))


                    Text(data.secondaryText)
                        .bold()
                        .font(.system(size: 25, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
//                        .animation(Animation.interpolatingSpring(stiffness: 100, damping: 10))

                    Spacer()
                        .frame(height: 60)

                })
                    .ignoresSafeArea()
            }

        }

    }
}

