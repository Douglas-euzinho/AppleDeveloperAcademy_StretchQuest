//
//  GameCenter.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 18/10/21.
//

import Foundation
import UIKit
import GameKit
import GameplayKit

extension ProfileViewController: GKGameCenterControllerDelegate{
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - chamar essa função para fzr a autenticação do usuário. Deve ser chamado no momento da abertura do app
    func authenticateUser(){
        let localUser = GKLocalPlayer.local
        localUser.authenticateHandler = {
            (view, Error) in
            
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            }else{
                print(GKLocalPlayer.local.isAuthenticated)
                self.gameCenterEnabled = true
            }
        }
    }
    
    
    //MARK: - função para salvar os placares
    //função para salvar o placar de força
    func countStrengthSessions(number: Int){
        if GKLocalPlayer.local.isAuthenticated{
            GKLeaderboard.submitScore(number, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["StrengthStretches"]){error in
                if let error = error{
                    print(error.localizedDescription)
                }else{}
            }
        }
    }
    func getStrengthScore(){
        if GKLocalPlayer.local.isAuthenticated{
            var leader = GKLeaderboard()
            GKLeaderboard.loadLeaderboards(IDs: ["StrengthStretches"]) { [] (boards, error) in
                if let PostureStretches = boards?.first{
                    leader = PostureStretches
                    leader.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) { [] (local, entries, error) in
                        if let score = local?.score{
                            let opa = score
                            self.countStrengthSessions(number: opa+1)
                            print("força: \(opa), força: \(score)")
                        }
                    }
                }
            }
        }
    }
    
    //função para salvar o placar de flexibilidade
    func countFlexibilitySessions(number: Int){
        if GKLocalPlayer.local.isAuthenticated{
            GKLeaderboard.submitScore(number, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["FlexibilityStretches"]){error in
                if let error = error{
                    print(error.localizedDescription)
                }else{}
            }
        }
    }
    func getFlexibilityScore(){
        if GKLocalPlayer.local.isAuthenticated{
            var leader = GKLeaderboard()
            
            GKLeaderboard.loadLeaderboards(IDs: ["FlexibilityStretches"]) { [] (boards, error) in
                if let PostureStretches = boards?.first{
                    leader = PostureStretches
                    leader.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) { [] (local, entries, error) in
                        if let score = local?.score{
                            let opa = score
                            self.countFlexibilitySessions(number: opa+1)
                            print("flexibilidade: \(opa), flexibilidade: \(score)")
                        }
                    }
                }
            }
        }
    }
    
    //função para salvar o placar de postura
    func countPostureSessions(number: Int){
        if GKLocalPlayer.local.isAuthenticated{
            GKLeaderboard.submitScore(number, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["PostureStretches"]){error in
                if let error = error{
                    print(error.localizedDescription)
                }else{}
            }
        }
    }
    func getPostureScore(){
        if GKLocalPlayer.local.isAuthenticated{
            var leader = GKLeaderboard()
            
            GKLeaderboard.loadLeaderboards(IDs: ["PostureStretches"]) { [] (boards, error) in
                if let PostureStretches = boards?.first{
                    leader = PostureStretches
                    leader.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) { [] (local, entries, error) in
                        if let score = local?.score{
                            let opa = score
                            self.countPostureSessions(number: opa+1)
                            print("posture: \(opa), posture: \(score)")
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - função para chamar e enviar o placar pro GC. Deve ser chamado essa função ao final da sessão
    //função para enviar o placar de força
    func callGameCenterStrength(_ sender: Any){
        getStrengthScore()
    }
    
    //função para enviar o placar de flexibilidade
    func callGameCenterFlexibility(_ sender: Any){
        getFlexibilityScore()
    }
    
    //função para enviar o placar de postura
    func callGameCenterPosture(_ sender: Any){
        getPostureScore()
    }
    
    
    //MARK: - função para mostrar os leaderboards. Chamado ao clicar em algum botão específico.
    func transitionToLeadersGameCenter(){
        let viewController = GKGameCenterViewController(state: .leaderboards)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: - função para mostrar os achievements. Chamado ao clicar em algum botão específico.
    func transitionToAchievementsGameCenter(){
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: - função para mostrar a tela principal. Chamado ao clicar em algum botão específico.
    func transitionToGameCenterPage(){
        let viewController = GKGameCenterViewController(state: .default)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
        self.getPostureScore()
    }
    
    //MARK: - Função geral para desbloquear conquista especificada no parâmetro. Chamado em qualquer canto
    func unlockAchievementSpecified(nameAchievement: String){
        let achievement = GKAchievement(identifier: nameAchievement)
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        GKAchievement.report([achievement]) { error in
            guard error == nil else{
                print(error?.localizedDescription ?? "")
                return
            }
            print("Desbloqueado: \(nameAchievement)")
        }
    }
    
    
}
