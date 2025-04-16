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
    var id: UUID
    var timestamp: Date
    var title: String
    var habitDescription: String
    var weekdays: [Int]
    var startTime: Date?
    var endTime: Date?
    var isNotificationEnabled: Bool
    var notificationTime: Date?
    var isCompleted: Bool?
    
    init(timestamp: Date, title: String, habitDescription: String, weekdays: [Int], startTime: Date? = nil, endTime: Date? = nil, isNotificationEnabled: Bool = false, notificationTime: Date? = nil, isCompleted: Bool? = nil) {
        self.id = UUID()
        self.timestamp = timestamp
        self.title = title
        self.habitDescription = habitDescription
        self.weekdays = weekdays
        self.startTime = startTime
        self.endTime = endTime
        self.isNotificationEnabled = isNotificationEnabled
        self.notificationTime = notificationTime
        self.isCompleted = isCompleted
    }
    
}
