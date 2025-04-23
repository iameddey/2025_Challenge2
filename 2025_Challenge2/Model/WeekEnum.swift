//
//  WeekEunm.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/20/25.
//

import Foundation

enum WeekEnum: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var id: Int {
        rawValue
    }
    
    var korSetup: String {
        switch self {
        case .sunday: return "일"
        case .monday: return "월"
        case .tuesday: return "화"
        case .wednesday: return "수"
        case .thursday: return "목"
        case .friday: return "금"
        case .saturday: return "토"
        }
    }
    
    static func from(date: Date) -> WeekEnum {
        let weekday = Calendar.current.component(.weekday, from: date)
        return WeekEnum(rawValue: weekday)!
    }
    
}
