//
//  DateFormatter.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/22/25.
//

import Foundation

extension DateFormatter {
    
    // 오늘 날짜 불러오기 (한국어)
    static let koreanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }()
    
}
