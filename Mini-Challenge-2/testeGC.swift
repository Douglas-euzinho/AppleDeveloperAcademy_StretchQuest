//
//  testeGC.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 18/10/21.
//

import Foundation
import UIKit
import GameKit
import GameplayKit

/*
 AQUI É UM EXEMPLO DE ONDE SERIA PRA CHAMAR AS FUNÇÕES DE AUTENTICAÇÃO
 */

class testeGC: UIViewController{
    //checar se foi autenticado ou não
    var gameCenterEnabled: Bool = false
    
    
    //placar aleatorio q eu criei só pra exemplificar
    var sessionStrengthDid: Int = 0
    var sessionFlexibilityDid: Int = 0
    var sessionPostureDid: Int = 0
    
    override func viewDidLoad() {
        self.authenticateUser()
    }
    
    
}

