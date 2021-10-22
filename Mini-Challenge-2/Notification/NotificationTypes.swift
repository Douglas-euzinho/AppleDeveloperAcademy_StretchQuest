//
//  NotificationTypes.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 20/10/21.
//

import Foundation
import UIKit


struct notificationInfoWithoutTime{
    var id: Int
    var title: String
    var subtitle: String
}

let notificationsInfosWithoutTime = [

    notificationInfoWithoutTime(id: 0, title: "Forte como um guerreiro!", subtitle: "Que tal dar uma fortalecida??"),
    
    notificationInfoWithoutTime(id: 1, title: "Elegante como um mago!", subtitle: "Bora alongar para melhorar essa postura??"),
    
    notificationInfoWithoutTime(id: 2, title: "Flexível como um arqueiro!", subtitle: "Bora dar uma melhorada na flexibilidade??"),
    
    notificationInfoWithoutTime(id: 3, title: "Já se alongou hoje?!", subtitle: "Venha alongar um pouco! É bem rápido!"),
    
    notificationInfoWithoutTime(id: 4, title: "Já ganhou seus pontos hoje??", subtitle: "Escolha um e comece já! Não demora nada!")
]

struct notificationInfoTimeFixed{
    var id: Int
    var title: String
    var subtitle: String
    var timeFixed: Int
}

let notificationsInfosTimeFixed = [
    notificationInfoTimeFixed(id: 0, title: "Boom dia!", subtitle: "Que tal começar o dia dando uma alongadinha??", timeFixed: 8),
    
    notificationInfoTimeFixed(id: 1, title: "Cansado do trabalho?", subtitle: "Uma alongadinha vai te revigorar!!", timeFixed: 16),
    
    notificationInfoTimeFixed(id: 2, title: "Quase anoitecendo...", subtitle: "Que tal começar a noite dando um gás no alongamento?", timeFixed: 18),
    
]

struct notificationInfoTimeFree{
    var id: Int
    var title: String
    var subtitle: String
    var time: Int
    
}


let notificationInfosTimeFree = [
    
    notificationInfoTimeFree(id: 0, title: "Não esqueça dos seus atributos!!", subtitle: "Venha alongar rapidinho para não perdê-los!", time: 20),
    
    notificationInfoTimeFree(id: 1, title: "Esqueceu de se alongar??", subtitle: "Seus pontos são tão importantes quanto sua saúde!", time: 22)
]

