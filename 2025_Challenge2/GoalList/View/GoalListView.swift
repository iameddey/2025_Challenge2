//
//  HomeView.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/16/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct GoalListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [GoalList]

    @State private var showingAddGoalListView = false
    @State private var selectedDay: WeekEnum = WeekEnum.from(date: Date())
    
    var filteredItems: [GoalList] {
        let filtered = items.filter { goalList in
            goalList.weekdays.contains(selectedDay.rawValue)
        }
        
        return filtered.sorted { item1, item2 in
            if (item1.isCompleted ?? false) && !(item2.isCompleted ?? false) {
                return true
            }
            else if !(item1.isCompleted ?? false) && (item2.isCompleted ?? false) {
                return false
            }
            else {
                return false
            }
        }
    }
    
    private let notiManager = NotificationManager()
    
    var body: some View {
        VStack(spacing: 0) {
            Image("HomeBackGroundImg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 320)
                .padding(.top, 16)

            HStack {
                Text(DateFormatter.koreanDateFormatter.string(from: Date()))
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Button(action: {
                    showingAddGoalListView = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.mainColor)
                }
                .padding(.trailing, 16)
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)

            HStack(spacing: 12) {
                ForEach(WeekEnum.allCases, id: \.self) { week in
                    Button(action: {
                        selectedDay = week
                    }) {
                        Text(week.korSetup)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedDay == week ? .white : .gray)
                            .frame(width: 36, height: 36)
                            .background(selectedDay == week ? Color.mainColor : Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 16)

            if filteredItems.isEmpty {
                Spacer()
                Text("당신의 하루를 보여주세요 !")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                Spacer()
            } else {
                List {
                    ForEach(filteredItems) { item in
                        HStack {
                            Button(action: {
                                toggleItemCompletion(item)
                            }) {
                                Image(systemName: (item.isCompleted ?? false) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor((item.isCompleted ?? false) ? Color.subColor : .gray)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(PlainButtonStyle())

                            Text(item.title)
                                .font(.system(size: 16))
                                .strikethrough(item.isCompleted ?? false)
                                .foregroundColor((item.isCompleted ?? false) ? .gray : .primary)
                            
                            
                        }
                        .padding(.vertical, 4)
                        
                    }
                    .onDelete(perform: deleteItems)
                    .listRowBackground(Color(.systemGray6))

                }
                .listStyle(.plain)
                .padding(.top, 20)
                .background(Color(.systemGray6))
            }
            Spacer()
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingAddGoalListView) {
            GoalAddView(selectedDay: selectedDay.rawValue)
        }
        .onAppear {
            resetGoalsAtMidnight()
        }
    }

    private func toggleItemCompletion(_ item: GoalList) {
        item.isCompleted = !(item.isCompleted ?? false)
        do {
            try modelContext.save()
        } catch {
            print("Failed to update item completion status: \(error.localizedDescription)")
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            let itemsToDelete = offsets.map { filteredItems[$0] }
            for item in itemsToDelete {
                if let index = items.firstIndex(where: { $0.id == item.id }) {
                    modelContext.delete(items[index])
                    notiManager.checkScheduledNotifications()
                }
            }
            do {
                try modelContext.save()
                // TODO: 나중에 없애야 함
//                notiManager.cancelAllNotifications()
            } catch {
                print("Failed to delete item: \(error.localizedDescription)")
            }
        }
    }
    

    private func resetGoalsAtMidnight() {
        let todayStart = Calendar.current.startOfDay(for: Date())
        var needsSave = false
        for item in items {
            if let lastChecked = item.lastCheckedDate {
                if !Calendar.current.isDate(lastChecked, inSameDayAs: todayStart) {
                    item.isCompleted = false
                    item.lastCheckedDate = todayStart
                    needsSave = true
                }
            } else {
                item.lastCheckedDate = todayStart
                needsSave = true
            }
        }
        if needsSave {
            do {
                try modelContext.save()
            } catch {
                print("Error resetting goals at midnight: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    GoalListView()
        .modelContainer(for: GoalList.self, inMemory: true)
}
