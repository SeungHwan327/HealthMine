import SwiftUI
import Charts

// MARK: - 볼륨 차트 표시용 데이터 구조체
struct CategoryVolumeData: Identifiable {
    var id = UUID()
    var date: Date
    var category: String
    var volume: Double
}

// MARK: - 볼륨 메인 뷰
struct VolumeView: View {
    @Binding var dailyLogs: [String: DailyLog]
    var userWeight: Double
    
    // 1. 전체 볼륨 데이터 변환
    private var allVolumeData: [CategoryVolumeData] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        let calendar = Calendar.current
        
        var result: [CategoryVolumeData] = []
        
        for (dateKey, log) in dailyLogs {
            // "M/d" 포맷 문자열을 Date로 변환 (연도는 현재 연도 기준)
            if let date = formatter.date(from: dateKey) {
                let currentYear = calendar.component(.year, from: Date())
                var components = calendar.dateComponents([.month, .day], from: date)
                components.year = currentYear
                
                if let fullDate = calendar.date(from: components) {
                    let vol = log.totalDailyVolume(userWeight: userWeight)
                    if vol > 0 {
                        result.append(CategoryVolumeData(date: fullDate, category: log.workoutCategory, volume: vol))
                    }
                }
            }
        }
        
        // 날짜순 오름차순 정렬
        return result.sorted { $0.date < $1.date }
    }
    
    // 2. 분할별 평균 볼륨 계산
    private func averageVolume(for category: String) -> Double {
        let filtered = allVolumeData.filter { $0.category == category }
        guard !filtered.isEmpty else { return 0 }
        let sum = filtered.reduce(0) { $0 + $1.volume }
        return sum / Double(filtered.count)
    }
    
    // 3. 분할별 최고 볼륨(PR) 계산
    private func maxVolume(for category: String) -> Double {
        allVolumeData.filter { $0.category == category }.map { $0.volume }.max() ?? 0
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - 1. 분할별 평균 & 최고 기록 카드
                VStack(alignment: .leading, spacing: 12) {
                    Text("분할별 볼륨 요약")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        CategorySummaryCard(title: "푸쉬", color: .red, avg: averageVolume(for: "푸쉬"), max: maxVolume(for: "푸쉬"))
                        CategorySummaryCard(title: "풀", color: .blue, avg: averageVolume(for: "풀"), max: maxVolume(for: "풀"))
                        CategorySummaryCard(title: "레그", color: .green, avg: averageVolume(for: "레그"), max: maxVolume(for: "레그"))
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // MARK: - 2. 전체 볼륨 추이 그래프
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("볼륨 추이 그래프")
                            .font(.headline)
                        Spacer()
                        Text("단위: kg")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    if allVolumeData.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "chart.bar.xaxis")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("기록된 볼륨 데이터가 없습니다.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, minHeight: 180)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        Chart(allVolumeData) { item in
                            BarMark(
                                x: .value("날짜", item.date, unit: .day),
                                y: .value("볼륨", item.volume)
                            )
                            .foregroundStyle(by: .value("분할", item.category))
                            .cornerRadius(4)
                        }
                        .chartForegroundStyleScale([
                            "푸쉬": Color.red,
                            "풀": Color.blue,
                            "레그": Color.green
                        ])
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("볼륨 분석")
    }
}

// MARK: - 분할 요약 카드 컴포넌트
struct CategorySummaryCard: View {
    let title: String
    let color: Color
    let avg: Double
    let max: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(title)
                    .font(.subheadline)
                    .bold()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("평균")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("\(Int(avg)) kg")
                    .font(.footnote)
                    .bold()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("최고(PR)")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("\(Int(max)) kg")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
