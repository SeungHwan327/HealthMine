import Foundation

// 세트 아이템
struct SetItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var weight: String // "20", "맨몸", "0" 등
    var reps: String   // "10"
}

// 운동 종목
struct ExerciseItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var sets: [SetItem]
    
    // 종목별 총 볼륨 계산 (userWeight: 맨몸 운동 시 사용할 사용자 체중)
    func calculateTotalVolume(userWeight: Double) -> Double {
        var total: Double = 0.0
        for set in sets {
            let reps = Double(set.reps) ?? 0.0
            let trimmedWeight = set.weight.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var weightValue: Double = 0.0
            if trimmedWeight == "맨몸" || trimmedWeight == "0" || trimmedWeight.isEmpty {
                weightValue = userWeight
            } else {
                weightValue = Double(trimmedWeight) ?? 0.0
            }
            
            total += weightValue * reps
        }
        return total
    }
}

// 하루 운동 기록
struct DailyLog: Codable, Hashable {
    var workoutCategory: String // "푸쉬", "풀", "레그" 등
    var booster: String
    var exercises: [ExerciseItem]
    
    // 하루 전체 총 볼륨 계산
    func totalDailyVolume(userWeight: Double) -> Double {
        exercises.reduce(0) { $0 + $1.calculateTotalVolume(userWeight: userWeight) }
    }
}

// 프로필 데이터
struct UserProfile: Codable {
    var weight: Double = 70.0 // 기본 체중 설정 (kg)
}
