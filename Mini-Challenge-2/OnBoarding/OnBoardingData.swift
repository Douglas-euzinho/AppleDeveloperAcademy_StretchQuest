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
    
    static let defaultBackground = [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]
    
    static let list: [OnboardingData] = [
        OnboardingData(id: 0, background: defaultBackground, imagePath: "nil", primaryText: "Stretches are important", secondaryText: "Even the bravest adventurers can feel the disavantages of not stretching their muscles before a battle"),
        OnboardingData(id: 1, background: defaultBackground, imagePath: "nil", primaryText: "Teste 2", secondaryText: "nil"),
        OnboardingData(id: 2, background: defaultBackground, imagePath: "nil", primaryText: "Teste 3", secondaryText: "nil")
    ]

}


struct MainHomeViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let story = UIStoryboard(name: "Main", bundle: nil)
        return story.instantiateViewController(withIdentifier: "HomeViewController")
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    
    }
}

struct OnboardingView: View {
    
    @State private var presented = false
    var data: OnboardingData
    var page: Int

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [data.background[0], data.background[1]]),startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 40, content: {
                    
                    Image(data.imagePath)
                    //    .resizable()
                        .scaledToFit()
                    
                    Text(data.primaryText)
                        .bold().font(.largeTitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                        .padding()
                        .multilineTextAlignment(.center)
//                    Spacer()
//                        .frame(height: 10)
                    Text(data.secondaryText)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 20)
                    if page == 2 {
                        Button("START") {
                            self.presented.toggle()
                        }
                        .fullScreenCover(isPresented: $presented, content: MainHomeViewController.init)
                    }

                })

            }

        }
    }
}
