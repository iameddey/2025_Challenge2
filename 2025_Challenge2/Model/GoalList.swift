//
//  GoalList.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class GoalList: ObservableObject {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var title: String
    var habitDescription: String
    var weekdays: [Int]
    var isNotificationEnabled: Bool
    var notificationTime: Date?
    var isCompleted: Bool?
    var lastCheckedDate: Date? 
    
    init(timestamp: Date, title: String, habitDescription: String, weekdays: [Int], isNotificationEnabled: Bool = false, notificationTime: Date? = nil, isCompleted: Bool? = nil, lastCheckedDate: Date? = nil) {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
        self.habitDescription = habitDescription
        self.weekdays = weekdays
        self.isNotificationEnabled = isNotificationEnabled
        self.notificationTime = notificationTime
        self.isCompleted = isCompleted
        self.lastCheckedDate = lastCheckedDate
    }
}
