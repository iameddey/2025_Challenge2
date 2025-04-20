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
    @State private var weekdays: [Int] = []
    @State private var isNotificationEnabled: Bool = false
    @State private var notificationTime: Date = Date()
        
    var isSaveEnabled: Bool {
        return !title.isEmpty && !habitDescription.isEmpty
    }
    
    var selectedDaysText: String {
        let allSelectedDays = (weekdays + [selectedDay]).unique().sorted()
        return allSelectedDays
            .compactMap{ WeekEnum (rawValue: $0)?.korSetup }
            .joined(separator: ", ")
    }
    
    init(selectedDay: Int) {
        self.selectedDay = selectedDay
        _weekdays = State(initialValue: [])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("목표 정보")) {
                        TextField("습관 이름", text: $title)
                        TextField("습관 설명", text: $habitDescription)
                    }
                    
                    Section(header: Text("추가 할 요일")) {
                        HStack(spacing: 10) {
                            ForEach(WeekEnum.allCases, id: \.self) { week in
                                let day = week.rawValue
                        
                                Button(action: {
                                    if day != selectedDay {
                                        toggleWeekday(day)
                                    }
                                }) {
                                    Text(week.korSetup)
                                        .font(.body)
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(day == selectedDay || weekdays.contains(day) ? .white : .gray)
                                        .background(day == selectedDay || weekdays.contains(day) ? Color.mainColor : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(day == selectedDay ? Color.black : Color.clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                                .background(day == selectedDay ? Color.mainColor : Color.clear)
                                .clipShape(Circle())
                                .disabled(day == selectedDay)
                                .foregroundColor(day == selectedDay || weekdays.contains(day) ? .white : .gray)
                            }
                        }
                        HStack {
                            Text("선택된 요일: \(selectedDaysText)")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    Section(header: Text("알람 설정하기")) {
                        Toggle("알람 활성화", isOn: $isNotificationEnabled)
                            .tint(Color.mainColor)
                        if isNotificationEnabled {
                            DatePicker("알람 시간", selection: $notificationTime, displayedComponents: .hourAndMinute)
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
        let allSelectedDays = (weekdays + [selectedDay]).unique().sorted()
        
        let newGoal = GoalList(
            timestamp: Date(),
            title: title,
            habitDescription: habitDescription,
            weekdays: allSelectedDays,
            isNotificationEnabled: isNotificationEnabled,
            notificationTime: isNotificationEnabled ? notificationTime : nil
        )
        modelContext.insert(newGoal)
    }
    
    func toggleWeekday(_ day: Int) {
        if weekdays.contains(day) {
            weekdays.removeAll { $0 == day }
        } else {
            weekdays.append(day)
        }
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}

#Preview {
    GoalAddView(selectedDay: 1)
}
