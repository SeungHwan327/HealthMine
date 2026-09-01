import SwiftUI

// MARK: - Models & Enums
enum WorkoutRoute: Hashable {
    case typeSelection(dateKey: String)
    case detail(dateKey: String, category: String, booster: String, exercises: [ExerciseItem])
}

// MARK: - 1. 메인 일지 뷰
struct MainJournalView: View {
    @Binding var dailyLogs: [String: DailyLog]
    let userProfile: UserProfile
    
    @State private var path = NavigationPath()
    
    // YYYY-MM-dd 날짜 포맷
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 20) {
                    // 오늘 날짜 일지 기록 여부 표시
                    if let log = dailyLogs[todayKey] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("오늘 작성된 일지")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("종류: \(log.workoutCategory)")
                                .font(.headline)
                            Text("부스터: \(log.booster.isEmpty ? "없음" : log.booster)")
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    } else {
                        Text("오늘 작성된 운동 일지가 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.vertical, 20)
                    }
                    
                    // 커스텀 일지 그리드 뷰 연동
                    JournalGridView(dailyLogs: $dailyLogs, userWeight: userProfile.weight)
                    
                    Spacer()
                    
                    // 운동 작성 버튼
                    Button(action: {
                        path.append(WorkoutRoute.typeSelection(dateKey: todayKey))
                    }) {
                        Text("오늘 운동 일지 작성하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("운동 일지")
            .navigationDestination(for: WorkoutRoute.self) { route in
                switch route {
                case .typeSelection(let dateKey):
                    WorkoutTypeSelectionView(
                        dateKey: dateKey,
                        dailyLogs: $dailyLogs,
                        path: $path
                    )
                case .detail(let dateKey, let category, let booster, let exercises):
                    JournalDetailView(
                        dateKey: dateKey,
                        dailyLogs: $dailyLogs,
                        initialCategory: category,
                        initialBooster: booster,
                        initialExercises: exercises,
                        path: $path
                    )
                }
            }
        }
    }
}

// MARK: - 2. 운동 종류/분할 선택 뷰
struct WorkoutTypeSelectionView: View {
    let dateKey: String
    @Binding var dailyLogs: [String: DailyLog]
    @Binding var path: NavigationPath
    
    let presets = ["푸쉬", "풀", "레그"]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(dateKey) 운동 종류 선택")
                .font(.title2)
                .bold()
                .padding(.top, 30)
            
            Text("오늘 할 운동 분할을 선택하세요.\n가장 최근 작성한 해당 분할의 루틴을 불러옵니다.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                ForEach(presets, id: \.self) { preset in
                    Button(action: { selectPreset(preset) }) {
                        HStack {
                            Text(preset)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                
                Divider().padding(.vertical, 8)
                
                Button(action: { selectPreset("기타") }) {
                    HStack {
                        Text("직접 입력 / 기타")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("\(dateKey) 선택")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func selectPreset(_ category: String) {
        var boosterToLoad = ""
        var exercisesToLoad: [ExerciseItem] = []
        
        if let existing = dailyLogs[dateKey], existing.workoutCategory == category {
            boosterToLoad = existing.booster
            exercisesToLoad = existing.exercises
        } else if let recentLog = findMostRecentLog(for: category) {
            boosterToLoad = recentLog.booster
            exercisesToLoad = recentLog.exercises.map { ex in
                ExerciseItem(
                    name: ex.name,
                    sets: ex.sets.map { SetItem(weight: $0.weight, reps: $0.reps) }
                )
            }
        } else {
            boosterToLoad = ""
            exercisesToLoad = [
                ExerciseItem(
                    name: "",
                    sets: (1...4).map { _ in SetItem(weight: "", reps: "") }
                )
            ]
        }
        
        path.append(WorkoutRoute.detail(
            dateKey: dateKey,
            category: category,
            booster: boosterToLoad,
            exercises: exercisesToLoad
        ))
    }
    
    private func findMostRecentLog(for category: String) -> DailyLog? {
        let matchingLogs = dailyLogs.filter { key, log in
            key != dateKey && log.workoutCategory == category
        }
        return Array(matchingLogs.values).last
    }
}

// MARK: - 3. 상세 메모장 뷰
struct JournalDetailView: View {
    let dateKey: String
    @Binding var dailyLogs: [String: DailyLog]
    @Binding var path: NavigationPath
    
    @State var workoutCategory: String
    @State var booster: String
    @State var exercises: [ExerciseItem]
    
    init(dateKey: String, dailyLogs: Binding<[String: DailyLog]>, initialCategory: String, initialBooster: String, initialExercises: [ExerciseItem], path: Binding<NavigationPath>) {
        self.dateKey = dateKey
        self._dailyLogs = dailyLogs
        self._workoutCategory = State(initialValue: initialCategory)
        self._booster = State(initialValue: initialBooster)
        self._exercises = State(initialValue: initialExercises)
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("기본 정보")) {
                    TextField("오늘의 운동 종류 (예: 푸쉬, 가슴)", text: $workoutCategory)
                    TextField("섭취한 부스터 입력", text: $booster)
                }
                
                Section(header: Text("운동 상세 목록")) {
                    List {
                        ForEach($exercises) { $exercise in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                    
                                    TextField("운동 명칭", text: $exercise.name)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Button(role: .destructive) {
                                        deleteExerciseItem(exercise.id)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.borderless)
                                }
                                
                                Divider()
                                
                                ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { setIndex, _ in
                                    HStack(spacing: 8) {
                                        Text("\(setIndex + 1)세트")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.secondary)
                                            .frame(width: 45, alignment: .leading)
                                        
                                        TextField("무게", text: $exercise.sets[setIndex].weight)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(.roundedBorder)
                                        Text("kg")
                                            .font(.caption)
                                        
                                        TextField("횟수", text: $exercise.sets[setIndex].reps)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(.roundedBorder)
                                        Text("회")
                                            .font(.caption)
                                        
                                        if exercise.sets.count > 1 {
                                            Button {
                                                exercise.sets.remove(at: setIndex)
                                            } label: {
                                                Image(systemName: "minus.circle")
                                                    .foregroundColor(.gray)
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                }
                                
                                Button {
                                    exercise.sets.append(SetItem(weight: "", reps: ""))
                                } label: {
                                    Label("세트 추가", systemImage: "plus.circle")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.borderless)
                                .padding(.top, 4)
                            }
                            .padding()
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(12)
                        }
                        .onMove(perform: moveExercise)
                    }
                    
                    Button(action: addExercise) {
                        Label("새 운동 종목 추가", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderless)
                    .padding(.vertical, 4)
                }
            }
            
            // 운동 종료 버튼
            Button(action: finishWorkout) {
                Text("운동 종료")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .navigationTitle("\(dateKey) 메모장")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, .constant(.active))
    }
    
    private func addExercise() {
        let defaultSets = (1...4).map { _ in SetItem(weight: "", reps: "") }
        exercises.append(ExerciseItem(name: "", sets: defaultSets))
    }
    
    private func deleteExerciseItem(_ id: UUID) {
        exercises.removeAll { $0.id == id }
    }
    
    private func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    private func finishWorkout() {
        let log = DailyLog(
            workoutCategory: workoutCategory,
            booster: booster,
            exercises: exercises
        )
        dailyLogs[dateKey] = log
        
        // 디스크(UserDefaults)에 즉시 영구 저장
        if let encoded = try? JSONEncoder().encode(dailyLogs) {
            UserDefaults.standard.set(encoded, forKey: "savedDailyLogs")
        }
        
        // 최상위 화면으로 한 번에 Pop
        path = NavigationPath()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
