//
//  Weekday.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/21/25.
//

import Foundation
import SwiftData

@Model
final class GoalList {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var title: String
    var habitDescription: String
    
    @Relationship(deleteRule: .cascade) var weekdayObjects: [WeekdayObject]?
    
    var isNotificationEnabled: Bool
    var notificationTime: Date?
    var isCompleted: Bool?
    var lastCheckedDate: Date?
    
    var weekdays: [Int] {
        get {
            return weekdayObjects?.map { $0.value } ?? []
        }
    }
    
    init(timestamp: Date, title: String, habitDescription: String, weekdays: [Int], isNotificationEnabled: Bool = false, notificationTime: Date? = nil, isCompleted: Bool? = nil, lastCheckedDate: Date? = nil) {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
        self.habitDescription = habitDescription
        self.weekdayObjects = weekdays.map { WeekdayObject(value: $0) }
        self.isNotificationEnabled = isNotificationEnabled
        self.notificationTime = notificationTime
        self.isCompleted = isCompleted
        self.lastCheckedDate = lastCheckedDate
    }
}
