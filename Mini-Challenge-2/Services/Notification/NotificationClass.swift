//
//  NotificationClass.swift
//  Mini-Challenge-2
//
//  Created by Douglas Figueirôa on 22/10/21.
//


import Foundation
import UIKit

//Aqui fica tudo relacionado a notificação
class NotificationClass{
    
    static let sharedNC = NotificationClass()
    
    //NOTIFICAÇÃO
    var day2: Int = 0
    var firstNotification: Bool = true
    
    func notificationAppear() {
        //print("entrou?")
        let timeHour = getLastTimeUser()
        let seconds = randomTimeNotification()
        self.day2 = getLastDayUser()
        self.firstNotification = false
        //print("testezin tlg: \(seconds)")
        let number = Int.random(in: 0..<2)
    //  print("number: \(number)")
        createNotificationTime(numberChoise: number, timeLastUse: timeHour)
        createNotificationRandom(timeLastUse: timeHour, secondsChoised: seconds)
       // print("id: \(idNotificationWithoutTime)")
    }
    
    //MARK: - Função pra criar a notificação com horário ou randômico
    func createNotificationTime(numberChoise: Int, timeLastUse: Int){
        let allNotiTimeFixed = notificationsInfosTimeFixed.count
        let allNotiTimeFree = notificationInfosTimeFree.count
        
        let idNotificationWithTimeFixed = Int.random(in: 0..<allNotiTimeFixed)
        let idNotificationWithTimeFree = Int.random(in: 0..<allNotiTimeFree)
        
        //print("tempo fixo: \(idNotificationWithTimeFixed)")
        //print("tempo livre: \(idNotificationWithTimeFree)")
        
        var x: Int = 0
        
        let content = UNMutableNotificationContent()
        
        switch numberChoise {
        case 0:
            notificationsInfosTimeFixed.forEach{ noti in
                if idNotificationWithTimeFixed == noti.id{
                    //print("id tempo fixado: \(idNotificationWithTimeFixed)")
                    content.title = noti.title
                    content.subtitle = noti.subtitle
                    
                    x = calculateTimeFixed(lastTimeUser: timeLastUse, timeNotification: noti.timeFixed)
                    
                }
            }
        case 1:
            notificationInfosTimeFree.forEach{ noti in
                if idNotificationWithTimeFree == noti.id{
                    //print("id tempo livre: \(idNotificationWithTimeFree)")
                    content.title = noti.title
                    content.subtitle = noti.subtitle
                    
                    x = calculateTimeFree(lastTimeUser: timeLastUse, timeNotification: noti.time)
                }
                
            }
        default:
            print("se entrou ak é pq ta errado mano slk")
        }
        
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeLastUse + x), repeats: false)
        //print("escolha: \(numberChoise), valor de x: \(x)")
            
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
        UNUserNotificationCenter.current().add(request)
        
    }
    
    //MARK: - Função para criar noti com algum horário randômico após a saída
    func createNotificationRandom(timeLastUse: Int, secondsChoised: Int){
        let _ = notificationsInfosWithoutTime.count
        
        let idNotificationWithoutTime = Int.random(in: 0..<notificationsInfosWithoutTime.count)
        let content = UNMutableNotificationContent()
        
        notificationsInfosWithoutTime.forEach{ noti in
            if idNotificationWithoutTime == noti.id{
                //print("id tempo aleatorio: \(idNotificationWithoutTime)")
                content.title = noti.title
                content.subtitle = noti.subtitle
                
            }
        }
        
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeLastUse+(secondsChoised-timeLastUse)), repeats: false)
        
            
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
    
    //MARK: - Função para escolher um tempo aleatório
    func randomTimeNotification() -> Int{
        //let times: [Int] = [86400,82800,79200,75600,72000,68400,64800,61200,57600,54000,50400,46800,43200,39600,36000,32400,28800,25200,21600,18000,14400,10800,7200]
        let times: [Int] = [5,10,15,20,25]
        return times.randomElement()!
    }
    
    //MARK: - Funções para calcular o tempo fixo e livre
    func calculateTimeFixed(lastTimeUser: Int, timeNotification: Int) -> Int{
        return ((((24-lastTimeUser) + timeNotification) * 3600) - lastTimeUser)
    }
    
    func calculateTimeFree(lastTimeUser: Int, timeNotification: Int) -> Int{
        return ((timeNotification*3600)-lastTimeUser)
    }
    
    //MARK: - Funções para calcular a hora e o dia do último uso
    func getLastTimeUser() -> Int{
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        //print("hours = \(hour)")
        return hour
    }
    
    func getLastDayUser() -> Int{
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        //print("day = \(day)")
        return day
    }
}
