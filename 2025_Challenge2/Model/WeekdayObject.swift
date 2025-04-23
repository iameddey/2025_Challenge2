//
//  WeekdayObject.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/21/25.
//

import Foundation
import SwiftData

@Model
final class WeekdayObject: Identifiable {
    @Attribute(.unique) var id: UUID
    var value: Int 
    @Relationship(inverse: \GoalList.weekdayObjects) var goal: GoalList?

    init(value: Int, goal: GoalList? = nil) {
        self.id = UUID()
        self.value = value
        self.goal = goal
    }
}

