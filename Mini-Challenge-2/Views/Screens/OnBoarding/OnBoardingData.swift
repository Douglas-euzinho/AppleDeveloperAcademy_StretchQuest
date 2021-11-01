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
        OnboardingData(id: 0, background: defaultBackground, imagePath: "onboard1", primaryText: "Welcome", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle"),
        OnboardingData(id: 1, background: defaultBackground2, imagePath: "onboard2", primaryText: "Attributes", secondaryText: "Increase your strength, flexibility or posture attributes with each stretching you perform"),
        OnboardingData(id: 2, background: defaultBackground3, imagePath: "onboard3", primaryText: "Profile", secondaryText: "As the stretchings are completed, you will get healthier and willing to confront your daily challenges. Ready to Stretch?")
    ]
}

struct OnboardingView: View {
    
    var data: OnboardingData
    @ObservedObject var delegate: OnboardDismissDelegate
    var index: Int
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [data.background[0], data.background[1]]), startPoint: .top, endPoint: .bottom)

            VStack(alignment: .center, content: {
                Spacer(minLength: 40)
                
                Image(data.imagePath)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: UIScreen.main.bounds.height / 2)
                
                Spacer()
                
                Text(data.primaryText)
                    .bold().font(.largeTitle)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                Text(data.secondaryText)
                    .bold()
                    .font(.system(size: 25, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .padding(.horizontal, 15)
                
                Spacer()
                
                CustomPageIndicatorWithContinueButton(
                    currentTab: data.id,
                    index: index,
                    delegate: delegate)
                    .padding(.bottom)
            })
        }
    }
}

