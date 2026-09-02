import SwiftUI

// MARK: - 프로필 뷰

struct ProfileView: View {

@Binding var userProfile: UserProfile

@State private var weightInput: String = ""

@State private var showSaveAlert = false

@State private var showErrorAlert = false

var body: some View {

    NavigationView {

        Form {

            // MARK: - 신체 정보

            Section(header: Text("신체 정보")) {

                HStack {

                    Text("현재 몸무게")

                    Spacer()

                    TextField(
                        "예: 70.5",
                        text: $weightInput
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)

                    Text("kg")
                }
            }

            // MARK: - 저장 버튼

            Section(
                footer: Text(
                    "저장한 몸무게는 맨몸 운동과 운동 볼륨 계산에 사용됩니다."
                )
            ) {

                Button {

                    saveWeight()

                } label: {

                    Text("체중 저장")
                        .frame(maxWidth: .infinity)
                }
            }
        }

        .navigationTitle("프로필")

        // MARK: - 현재 몸무게 표시

        .onAppear {

            weightInput = String(
                format: "%.1f",
                userProfile.weight
            )
        }

        // MARK: - 저장 완료 알림

        .alert(
            "저장 완료",
            isPresented: $showSaveAlert
        ) {

            Button("확인", role: .cancel) { }

        } message: {

            Text(
                "\(String(format: "%.1f", userProfile.weight))kg으로 저장되었습니다."
            )
        }

        // MARK: - 입력 오류 알림

        .alert(
            "입력 오류",
            isPresented: $showErrorAlert
        ) {

            Button("확인", role: .cancel) { }

        } message: {

            Text("올바른 몸무게를 입력해주세요.")
        }
    }
}

// MARK: - 몸무게 저장

private func saveWeight() {

    // 쉼표 입력 대응
    let formattedInput = weightInput
        .replacingOccurrences(
            of: ",",
            with: "."
        )
        .trimmingCharacters(in: .whitespaces)

    // 숫자로 변환
    guard let newWeight = Double(formattedInput),
          newWeight > 0 else {

        showErrorAlert = true

        return
    }

    // MARK: 프로필 업데이트

    userProfile.weight = newWeight

    // MARK: UserDefaults 저장

    userProfile.save()

    // 키보드 숨기기

    hideKeyboard()

    // 저장 완료 표시

    showSaveAlert = true
}

// MARK: - 키보드 숨기기

private func hideKeyboard() {

    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

}

#Preview {

ProfileView(
    userProfile: .constant(UserProfile())
)

}
