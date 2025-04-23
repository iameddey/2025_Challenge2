//
//  _025_Challenge2App.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/16/25.
//

import SwiftUI
import SwiftData
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // 알림 처리 로직
        print("알림이 탭됨: \(response.notification.request.identifier)")
    }
}


@main
struct GreenHabitApp: App {
    
    init() {
            NotificationManager.instance.requestAuthorization()
        }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GoalList.self,
            WeekdayObject.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    let manager = NotificationManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    manager.requestAuthorization()
                }
        }
        .modelContainer(sharedModelContainer)
        
    }
}
