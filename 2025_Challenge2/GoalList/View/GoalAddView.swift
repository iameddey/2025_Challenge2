//
//  GoalAddView.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/16/25.
//

import SwiftUI

struct GoalAddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let selectedDay: Int
    
    @State private var title: String = ""
    @State private var habitDescription: String = ""
    @State private var isNotificationEnabled: Bool = false
    @State private var notificationTime: Date = Date()
    
    let mainColor = Color(red: 0.965, green: 0.773, blue: 0.373)
    let weekdaysKor = ["일", "월", "화", "수", "목", "금", "토"]
    
    var isSaveEnabled: Bool {
        return !title.isEmpty && !habitDescription.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("목표 정보")) {
                        TextField("습관 이름", text: $title)
                        TextField("습관 설명", text: $habitDescription)
                    }
                    Section(header: Text("알람 설정하기")) {
                        Toggle("알람 활성화", isOn: $isNotificationEnabled)
                            .tint(mainColor)
                        if isNotificationEnabled {
                            HStack {
                                Text("선택된 요일: \(weekdaysKor[selectedDay-1])")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            DatePicker("알람 시간", selection: $notificationTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .navigationTitle("목표 설정하기")
                .toolbar { 
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveGoal()
                            dismiss()
                        }
                        .disabled(!isSaveEnabled)
                        .foregroundColor(isSaveEnabled ? .blue : .gray)
                    }
                }
            }
        }
    }
    
    func saveGoal() {
        let newGoal = GoalList(
            timestamp: Date(),
            title: title,
            habitDescription: habitDescription,
            weekdays: [selectedDay],  // Only use the selected day
            isNotificationEnabled: isNotificationEnabled,
            notificationTime: isNotificationEnabled ? notificationTime : nil
        )
        
        modelContext.insert(newGoal)
    }
}

#Preview {
    GoalAddView(selectedDay: 1)
}
