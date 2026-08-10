import SwiftUI

// MARK: - 프로필 뷰 (몸무게 입력 및 관리)
struct ProfileView: View {
    @Binding var userProfile: UserProfile
    @State private var weightInput: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("신체 정보")) {
                    HStack {
                        Text("현재 몸무게")
                        Spacer()
                        TextField("70", text: $weightInput)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("kg")
                    }
                }
                
                Section(footer: Text("무게란에 '맨몸' 또는 '0'을 입력하면 위 몸무게를 기준으로 볼륨(총 중량)이 자동 계산됩니다.")) {
                    Button("체중 저장") {
                        if let newWeight = Double(weightInput) {
                            userProfile.weight = newWeight
                            hideKeyboard()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("프로필")
            .onAppear {
                weightInput = String(format: "%.1f", userProfile.weight)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
