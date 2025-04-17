//
//  HomeView.swift
//  2025_Challenge2
//
//  Created by 김재윤 on 4/16/25.
//

import SwiftUI
import SwiftData

struct GoalListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [GoalList]
    
    @State private var showingAddGoalListView = false
    @State private var selectedDay: Int = Calendar.current.component(.weekday, from: Date())
    
    var filteredItems: [GoalList] {
        items.filter { $0.weekdays.contains(selectedDay) }
    }
    
    var mainColor: Color { Color(red: 0.965, green: 0.773, blue: 0.373) }
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("HomeBackGroundImg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 320)
                .padding(.top, 16)
            
            HStack {
                Text("나의 하루")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Text(todayString)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
            
            HStack(spacing: 12) {
                ForEach(0..<7) { idx in
                    Button(action: {
                        selectedDay = idx + 1
                    }) {
                        Text(weekdays[idx])
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedDay == idx + 1 ? .white : .gray)
                            .frame(width: 36, height: 36)
                            .background(selectedDay == idx + 1 ? mainColor : Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 16)
            
            HStack {
                Spacer()
                Button(action: {
                    showingAddGoalListView = true
                }) {
                    Text("추가하기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(mainColor)
                }
                .padding(.trailing, 32)
                .padding(.top, 15)
            }
            
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
                                    .foregroundColor((item.isCompleted ?? false) ? mainColor : .gray)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(item.title)
                                .font(.system(size: 16))
                                .strikethrough(item.isCompleted ?? false)
                                .foregroundColor((item.isCompleted ?? false) ? .gray : .primary)
                                .listRowBackground(Color(.systemGray6))
                        }
                        
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteItems)
                    .listRowBackground(Color(.systemGray6))
                }
                .listStyle(.plain)
                .padding(.top, 20)
            }
            Spacer()
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingAddGoalListView) { 
            GoalAddView()
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
            for index in offsets {
                let item = filteredItems[index]
                modelContext.delete(item)
            }
            do {
                try modelContext.save()
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
}
