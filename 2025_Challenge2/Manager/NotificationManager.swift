//
//  NotificationManager.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/21/25.
//

import Foundation
import SwiftUI
import SwiftData
import UserNotifications
import CoreLocation

class NotificationManager {
    static let instance = NotificationManager()
        
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("알림 권한이 허용되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
            
            if let error = error {
                print("알림 권한 요청 오류: \(error.localizedDescription)")
            }
        }

    }
    
    func scheduleNotification(for goal: GoalList) {
        guard goal.isNotificationEnabled, let notificationTime = goal.notificationTime else { return }
        
        let content = UNMutableNotificationContent()
        content.title = goal.title
        content.body = goal.habitDescription
        content.sound = .default
        content.badge = 1
        
        let weekday = goal.weekdays.first ?? Calendar.current.component(.weekday, from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: notificationTime)
        dateComponents.minute = Calendar.current.component(.minute, from: notificationTime)
        dateComponents.weekday = weekday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: goal.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for goalID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [goalID.uuidString])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 현재 예약된 알림 확인 (디버깅용)
    func checkScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("현재 예약된 알림 수: \(requests.count)")
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let components = trigger.dateComponents as DateComponents? {
                    print("알림 ID: \(request.identifier)")
                    print("제목: \(request.content.title)")
                    print("내용: \(request.content.body)")
                    print("요일: \(components.weekday ?? 0)")
                    print("시간: \(components.hour ?? 0):\(components.minute ?? 0)")
                    print("------------------------")
                }
            }
        }
    }
}
