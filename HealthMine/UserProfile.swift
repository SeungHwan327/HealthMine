import Foundation

// MARK: - 사용자 프로필 데이터

struct UserProfile: Codable {

// 기본 몸무게
var weight: Double = 70.0

// MARK: - 프로필 저장

func save() {

    do {

        let encodedData = try JSONEncoder().encode(self)

        UserDefaults.standard.set(
            encodedData,
            forKey: "savedUserProfile"
        )

        print("✅ 사용자 프로필 저장 완료")

    } catch {

        print("❌ 사용자 프로필 저장 실패: \(error)")
    }
}

// MARK: - 저장된 프로필 불러오기

static func load() -> UserProfile {

    // UserDefaults에서 저장된 데이터 가져오기
    guard let savedData = UserDefaults.standard.data(
        forKey: "savedUserProfile"
    ) else {

        // 저장된 데이터가 없으면 기본값 반환
        return UserProfile()
    }

    do {

        let decodedProfile = try JSONDecoder().decode(
            UserProfile.self,
            from: savedData
        )

        print("✅ 저장된 사용자 프로필 불러오기 완료")

        return decodedProfile

    } catch {

        print("❌ 사용자 프로필 불러오기 실패: \(error)")

        return UserProfile()
    }
}

}
