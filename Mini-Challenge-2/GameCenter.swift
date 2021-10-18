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

extension testeGC: GKGameCenterControllerDelegate{
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
    }//fim authenticateUser()
    
    
    //MARK: - função para salvar o placar
    func countStretches(number: Int){
        if GKLocalPlayer.local.isAuthenticated{
            GKLeaderboard.submitScore(number, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["bundle.nomeLeader"]){error in
                if let error = error{
                    print(error.localizedDescription)
                }else{}
            }
        }
    }//fim countStretches()
    
    
    //MARK: - função para chamar e enviar o placar pro GC. Deve ser chamado essa função ao final da sessão
    func callGameCenter(_ sender: Any){
        countStretches(number: stretchesDid)
    }//fim callGameCenter()
    
    
    //MARK: - função para mostrar os leaderboards. Chamado ao clicar em algum botão específico.
    func transitionToGameCenter(){
        let viewController = GKGameCenterViewController(state: .leaderboards)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }//fim transitionToGameCenter()
    
    
}
