import SwiftUI

struct JournalGridView: View {
    // 1. 외부(ContentView)에서 상태를 공유받기 위해 @Binding 및 프로퍼티 선언
    @Binding var dailyLogs: [String: DailyLog]
    var userWeight: Double
    
    @StateObject private var proteinManager = ProteinManager()
    
    // 내부에서 사용할 달력 현재 날짜 상태
    @State private var currentDate = Date()
    
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(spacing: 12) {
            // 월 이동 헤더
            HStack {
                Text(monthYearString(from: currentDate))
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .padding(8)
                }
                .buttonStyle(.borderless)
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .padding(8)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)
            
            // 요일 라벨
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .bold()
                        .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .gray))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // 1달 달력 격자 (ScrollView 제거: ContentView의 메인 ScrollView와 스크롤 중첩 방지)
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(generateDaysInMonth(for: currentDate), id: \.self) { dateItem in
                    if let date = dateItem {
                        let dateKey = dateKeyString(from: date)
                        let dayNum = Calendar.current.component(.day, from: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        let log = dailyLogs[dateKey]
                        let protein = proteinManager.protein(for: date)
                        
                        // 기존에 저장된 일지가 있는지 확인
                        let existingLog = dailyLogs[dateKey]

                        // 작성된 일지가 있으면 detail, 없으면 typeSelection으로 분기
                        let route: WorkoutRoute = {
                            if let log = existingLog {
                                return .detail(
                                    dateKey: dateKey,
                                    category: log.workoutCategory,
                                    booster: log.booster,
                                    exercises: log.exercises
                                )
                            } else {
                                return .splitSelection(dateKey: dateKey)
                            }
                        }()
                        
                        // 날짜 클릭 시 -> 분할 선택 화면(WorkoutTypeSelectionView)으로 이동
                        NavigationLink(value: route) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(dayNum)")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(isToday ? .white : .primary)
                                    .padding(4)
                                    .background(isToday ? Circle().fill(Color.blue) : Circle().fill(Color.clear))
                                
                                if let log = log, !log.workoutCategory.isEmpty {
                                    Text(log.workoutCategory)
                                        .font(.system(size: 9))
                                        .foregroundColor(.blue)
                                        .bold()
                                        .lineLimit(2)
                                        .padding(.horizontal, 2)
                                }
                                
                                if protein > 0 {
                                    Text("\(String(format: "%.0f", protein))g")
                                        .font(.system(size: 9))
                                        .foregroundColor(.blue)
                                        .bold()
                                        .padding(.horizontal, 2)
                                }
                                
                                Spacer(minLength: 0)
                            }
                            .frame(height: 65)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(6)
                        }
                    } else {
                        Color.clear.frame(height: 65)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월"
        return formatter.string(from: date)
    }
    
    private func dateKeyString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func generateDaysInMonth(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: monthFirstDay)
        let numberOfDays = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day ?? 0
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        for day in 0..<numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day, to: monthFirstDay) {
                days.append(date)
            }
        }
        return days
    }
}

// Xcode 미리보기용 코드
#Preview {
    JournalGridView(
        dailyLogs: .constant([:]),
        userWeight: 70.0
    )
}
