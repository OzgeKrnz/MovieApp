//
//  NotificationManager.swift
//  movieApp
//
//  Created by özge kurnaz on 17.06.2025.
//

import UserNotifications

struct NotificationManager{
    
    static func requestNotificationAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if granted {
                   print("Bildirim izni verildi.")
               } else if let error = error {
                   print("Bildirim izni reddedildi veya hata oluştu: \(error.localizedDescription)")
               }
           }
    }
    
    static func scheduleWelcomeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hoş Geldin!"
        content.body = "Film önerileri dünyasına hoş geldin! İlk film yorumunu yapmaya ne dersin?"
        content.sound = .default

        // 5 saniye sonra tetiklenecek
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "welcomeNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Hoş geldin bildirimi planlanırken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Hoş geldin bildirimi başarıyla planlandı.")
            }
        }
    }
}


