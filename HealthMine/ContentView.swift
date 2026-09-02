import SwiftUI

// MARK: - 메인 ContentView (하단 탭 바: 단백질, 일지, 캘린더, 볼륨, 프로필)
struct ContentView: View {
    // 1. 앱 시작 시 저장소에서 바로 데이터를 읽어와 초기화
    @State private var dailyLogs: [String: DailyLog] = {
        if let savedData = UserDefaults.standard.data(forKey: "savedDailyLogs"),
           let decoded = try? JSONDecoder().decode([String: DailyLog].self, from: savedData) {
            return decoded
        }
        return [:]
    }()
    
    @State private var userProfile = UserProfile.load()
    @State private var journalPath = NavigationPath()
    
    var body: some View {
        TabView {
            // 1. 단백질 탭
            NavigationView {
                ProteinView()
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("단백질")
            }
            
            // 2. 일지 탭
            NavigationStack(path: $journalPath) {
                ScrollView {
                    VStack(spacing: 20) {
                        JournalGridView(dailyLogs: $dailyLogs, userWeight: userProfile.weight)
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("운동 일지")
                .navigationDestination(for: WorkoutRoute.self) { route in

                    switch route {

                    case .splitSelection(let dateKey):

                        WorkoutSplitSelectionView(
                            dateKey: dateKey,
                            path: $journalPath
                        )

                    case .typeSelection(let dateKey):

                        WorkoutTypeSelectionView(
                            dateKey: dateKey,
                            dailyLogs: $dailyLogs,
                            path: $journalPath
                        )

                    case .fourSplitSelection(let dateKey):

                        Workout4SplitSelectionView(
                            dateKey: dateKey,
                            dailyLogs: $dailyLogs,
                            path: $journalPath
                        )

                    case .detail(
                        let dateKey,
                        let category,
                        let booster,
                        let exercises
                    ):

                        JournalDetailView(
                            dateKey: dateKey,
                            dailyLogs: $dailyLogs,
                            initialCategory: category,
                            initialBooster: booster,
                            initialExercises: exercises,
                            path: $journalPath
                        )
                    }
                }
            }
            .tabItem {
                Image(systemName: "doc.text")
                Text("일지")
            }
            
            // 3. 캘린더 탭
            NavigationView {
                VStack {
                    Text("캘린더")
                        .font(.largeTitle)
                        .bold()
                }
                .navigationTitle("캘린더")
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("캘린더")
            }
            
            // 4. 볼륨 탭
            NavigationView {
                VolumeView(dailyLogs: $dailyLogs, userWeight: userProfile.weight)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("볼륨")
            }
            
            // 5. 프로필 탭
            ProfileView(userProfile: $userProfile)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("프로필")
                }
        }
    }
    
    // MARK: - Persistence Logic (저장 함수)
    func saveLogsToDisk() {
        if let encoded = try? JSONEncoder().encode(dailyLogs) {
            UserDefaults.standard.set(encoded, forKey: "savedDailyLogs")
        }
    }
}
