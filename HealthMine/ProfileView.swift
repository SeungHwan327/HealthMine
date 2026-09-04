import SwiftUI
// MARK: - 프로필 뷰

struct ProfileView: View {

    @Binding var userProfile: UserProfile

    @State private var weightInput: String = ""
    @State private var showSaveAlert = false
    @State private var showErrorAlert = false

    var body: some View {

        NavigationView {

            ScrollView {

                VStack(spacing: 20) {

                    // MARK: - 프로필 카드

                    VStack(spacing: 12) {

                        // 프로필 아이콘
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 45))
                            .foregroundColor(.blue)
                            .frame(
                                width: 80,
                                height: 80
                            )
                            .background(
                                Color.blue.opacity(0.1)
                            )
                            .clipShape(Circle())

                        Text("나의 프로필")
                            .font(.title2)
                            .bold()

                        Text("꾸준한 기록으로 더 나은 운동을 만들어보세요.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 25)
                    .padding(.horizontal)
                    .background(
                        Color(.secondarySystemBackground)
                    )
                    .cornerRadius(20)


                    // MARK: - 신체 정보

                    VStack(alignment: .leading, spacing: 12) {

                        Text("신체 정보")
                            .font(.headline)

                        HStack(spacing: 12) {

                            // 현재 몸무게
                            VStack(alignment: .leading, spacing: 6) {

                                Image(systemName: "scalemass")
                                    .foregroundColor(.blue)

                                Text("현재 몸무게")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(
                                    "\(String(format: "%.1f", userProfile.weight)) kg"
                                )
                                .font(.title3)
                                .bold()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .cornerRadius(15)


                            // 몸무게 입력
                            VStack(alignment: .leading, spacing: 6) {

                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)

                                Text("몸무게 수정")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                TextField(
                                    "70.5",
                                    text: $weightInput
                                )
                                .keyboardType(.decimalPad)
                                .font(.title3)
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .cornerRadius(15)
                        }


                        Button {

                            saveWeight()

                        } label: {

                            Text("체중 저장")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)


                    // MARK: - 운동 통계

                    VStack(alignment: .leading, spacing: 12) {

                        Text("운동 통계")
                            .font(.headline)

                        HStack(spacing: 12) {

                            // 운동 횟수
                            VStack(spacing: 8) {

                                Image(
                                    systemName: "figure.run"
                                )
                                .font(.title2)
                                .foregroundColor(.blue)

                                Text("운동 횟수")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text("준비 중")
                                    .font(.headline)
                            }
                            .frame(
                                maxWidth: .infinity
                            )
                            .padding(.vertical, 18)
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .cornerRadius(15)


                            // 총 볼륨
                            VStack(spacing: 8) {

                                Image(
                                    systemName: "chart.bar.fill"
                                )
                                .font(.title2)
                                .foregroundColor(.blue)

                                Text("총 볼륨")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text("준비 중")
                                    .font(.headline)
                            }
                            .frame(
                                maxWidth: .infinity
                            )
                            .padding(.vertical, 18)
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .cornerRadius(15)
                        }

                        Text("운동 기록을 기반으로 통계를 계산할 수 있습니다.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)


                    // MARK: - 설정

                    VStack(alignment: .leading, spacing: 12) {

                        Text("설정")
                            .font(.headline)

                        VStack(spacing: 0) {

                            // 프로필 수정
                            Button {

                                // 추후 프로필 수정 기능 추가

                            } label: {

                                HStack {

                                    Image(systemName: "person.crop.circle")
                                        .foregroundColor(.blue)
                                        .frame(width: 25)

                                    Text("프로필 수정")
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Image(
                                        systemName: "chevron.right"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .padding()
                            }


                            Divider()
                                .padding(.leading, 55)


                            // 데이터 초기화
                            Button {

                                // 추후 데이터 초기화 기능 추가

                            } label: {

                                HStack {

                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .frame(width: 25)

                                    Text("데이터 초기화")
                                        .foregroundColor(.red)

                                    Spacer()

                                    Image(
                                        systemName: "chevron.right"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .padding()
                            }
                        }
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .cornerRadius(15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.large)

            // MARK: - 화면 진입 시 현재 몸무게 표시

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
            .trimmingCharacters(
                in: .whitespaces
            )

        // 숫자로 변환
        guard let newWeight = Double(formattedInput),
              newWeight > 0 else {

            showErrorAlert = true
            return
        }

        // 프로필 업데이트
        userProfile.weight = newWeight

        // UserDefaults 저장
        userProfile.save()

        // 키보드 숨기기
        hideKeyboard()

        // 저장 완료 표시
        showSaveAlert = true
    }


    // MARK: - 키보드 숨기기

    private func hideKeyboard() {

        UIApplication.shared.sendAction(
            #selector(
                UIResponder.resignFirstResponder
            ),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


#Preview {

    ProfileView(
        userProfile: .constant(
            UserProfile()
        )
    )
}

