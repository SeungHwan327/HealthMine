import SwiftUI

// MARK: - 메인 ContentView (하단 탭 바: 단백질, 일지, 캘린더, 볼륨, 프로필)
struct ContentView: View {
    @State private var dailyLogs: [String: DailyLog] = [:]
    @State private var userProfile = UserProfile()
    
    // 1. 내비게이션 경로 관리를 위한 State 추가
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
            
            // 2. 일지 탭 (NavigationView -> NavigationStack 변경 및 destination 설정)
            NavigationStack(path: $journalPath) {
                ScrollView {
                    VStack(spacing: 20) {
                        JournalGridView(dailyLogs: $dailyLogs, userWeight: userProfile.weight)
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("운동 일지")
                // 2. WorkoutRoute 값에 반응하는 이동 목적지 정의
                .navigationDestination(for: WorkoutRoute.self) { route in
                    switch route {
                    case .typeSelection(let dateKey):
                        WorkoutTypeSelectionView(
                            dateKey: dateKey,
                            dailyLogs: $dailyLogs,
                            path: $journalPath
                        )
                    case .detail(let dateKey, let category, let booster, let exercises):
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
            
            // 4. 볼륨 탭 (VolumeView 연동)
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
}
