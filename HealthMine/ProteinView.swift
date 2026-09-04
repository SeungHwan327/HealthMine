import SwiftUI

struct ProteinView: View {

    @StateObject private var proteinManager = ProteinManager()
    @State private var userProfile = UserProfile.load()

    @State private var showAddProtein = false
    @State private var recordToDelete: ProteinRecord?

    // 체중 1kg당 단백질 1.8g
    private let proteinRatio: Double = 1.8

    // MARK: - 계산

    private var proteinGoal: Double {
        userProfile.weight * proteinRatio
    }

    private var todayProtein: Double {
        proteinManager.todayProtein
    }

    private var remainingProtein: Double {
        max(proteinGoal - todayProtein, 0)
    }

    private var progress: Double {
        guard proteinGoal > 0 else {
            return 0
        }

        return min(todayProtein / proteinGoal, 1.0)
    }

    // 오늘 기록만 가져오기
    private var todayRecords: [ProteinRecord] {
        proteinManager.records
            .filter {
                Calendar.current.isDateInToday($0.date)
            }
            .sorted {
                $0.date > $1.date
            }
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    // 오늘의 단백질
                    todayProteinCard

                    // 섭취 현황
                    nutritionSummaryCard

                    // 단백질 목표
                    goalCard

                    // 기록 추가 버튼
                    addProteinButton

                    // 오늘의 기록
                    recordSection
                }
                .padding()
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationTitle("단백질")
            .navigationBarTitleDisplayMode(.large)

            // 단백질 기록 추가 화면
            .sheet(
                isPresented: $showAddProtein
            ) {
                AddProteinView(
                    proteinManager: proteinManager
                )
            }

            // 삭제 확인창
            .alert(
                "기록 삭제",
                isPresented: Binding(
                    get: {
                        recordToDelete != nil
                    },
                    set: { value in
                        if !value {
                            recordToDelete = nil
                        }
                    }
                )
            ) {

                Button(
                    "삭제",
                    role: .destructive
                ) {

                    if let record = recordToDelete {
                        proteinManager.deleteRecord(record)
                    }

                    recordToDelete = nil
                }

                Button(
                    "취소",
                    role: .cancel
                ) {
                    recordToDelete = nil
                }

            } message: {

                Text(
                    "\(recordToDelete?.foodName ?? "") 기록을 삭제하시겠습니까?"
                )
            }

            .onAppear {
                userProfile = UserProfile.load()
            }
        }
    }

    // MARK: - 오늘의 단백질 카드

    private var todayProteinCard: some View {

        VStack(spacing: 18) {

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text("오늘의 단백질")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 4
                    ) {

                        Text(
                            String(
                                format: "%.1f",
                                todayProtein
                            )
                        )
                        .font(
                            .system(
                                size: 42,
                                weight: .bold,
                                design: .rounded
                            )
                        )

                        Text("g")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                // 원형 진행률
                ZStack {

                    Circle()
                        .stroke(
                            Color.blue.opacity(0.12),
                            lineWidth: 10
                        )

                    Circle()
                        .trim(
                            from: 0,
                            to: progress
                        )
                        .stroke(
                            Color.blue,
                            style: StrokeStyle(
                                lineWidth: 10,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(
                            .degrees(-90)
                        )

                    Text(
                        "\(Int(progress * 100))%"
                    )
                    .font(.headline)
                    .bold()
                }
                .frame(
                    width: 80,
                    height: 80
                )
            }

            // 진행률 바
            VStack(spacing: 8) {

                HStack {

                    Text("오늘의 목표")
                        .font(.caption)

                    Spacer()

                    Text(
                        "\(String(format: "%.0f", proteinGoal))g"
                    )
                    .font(.caption)
                    .bold()
                }

                GeometryReader { geometry in

                    ZStack(alignment: .leading) {

                        Capsule()
                            .fill(
                                Color.gray.opacity(0.12)
                            )

                        Capsule()
                            .fill(Color.blue)
                            .frame(
                                width: geometry.size.width * progress
                            )
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - 섭취 현황 카드

    private var nutritionSummaryCard: some View {

        HStack(spacing: 0) {

            summaryItem(
                title: "섭취량",
                value: todayProtein
            )

            Divider()
                .frame(height: 45)

            summaryItem(
                title: "목표량",
                value: proteinGoal
            )

            Divider()
                .frame(height: 45)

            summaryItem(
                title: "남은 양",
                value: remainingProtein
            )
        }
        .padding(.vertical, 18)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
    }

    private func summaryItem(
        title: String,
        value: Double
    ) -> some View {

        VStack(spacing: 5) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(
                alignment: .firstTextBaseline,
                spacing: 2
            ) {

                Text(
                    String(
                        format: "%.0f",
                        value
                    )
                )
                .font(.headline)
                .bold()

                Text("g")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 목표 카드

    private var goalCard: some View {

        HStack(spacing: 14) {

            Image(systemName: "target")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(
                    width: 48,
                    height: 48
                )
                .background(
                    Color.blue.opacity(0.1)
                )
                .clipShape(Circle())

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text("나의 단백질 목표")
                    .font(.headline)

                Text(
                    "\(String(format: "%.1f", userProfile.weight))kg × 1.8g"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text(
                "\(String(format: "%.0f", proteinGoal))g"
            )
            .font(.headline)
            .bold()
        }
        .padding(18)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
    }

    // MARK: - 단백질 추가 버튼

    private var addProteinButton: some View {

        Button {

            showAddProtein = true

        } label: {

            HStack {

                Image(systemName: "plus")

                Text("단백질 기록 추가")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
    }

    // MARK: - 오늘의 기록

    private var recordSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("오늘의 기록")
                    .font(.title3)
                    .bold()

                Spacer()

                Text("\(todayRecords.count)개")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if todayRecords.isEmpty {

                emptyRecordView

            } else {

                VStack(spacing: 10) {

                    ForEach(todayRecords) { record in

                        recordCard(record)
                    }
                }
            }
        }
    }

    // MARK: - 기록 카드

    private func recordCard(
        _ record: ProteinRecord
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: "fork.knife")
                .foregroundStyle(.blue)
                .frame(
                    width: 42,
                    height: 42
                )
                .background(
                    Color.blue.opacity(0.1)
                )
                .clipShape(Circle())

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(record.foodName)
                    .font(.headline)

                Text(
                    record.date,
                    style: .time
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 2
            ) {

                Text(
                    "\(String(format: "%.1f", record.protein))g"
                )
                .font(.headline)
                .bold()

                Text("단백질")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            // 삭제 버튼
            Button {

                recordToDelete = record

            } label: {

                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundStyle(.red)
                    .frame(
                        width: 34,
                        height: 34
                    )
                    .background(
                        Color.red.opacity(0.08)
                    )
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }

    // MARK: - 기록이 없을 때

    private var emptyRecordView: some View {

        VStack(spacing: 10) {

            Image(
                systemName: "fork.knife.circle"
            )
            .font(.system(size: 38))
            .foregroundStyle(.secondary)

            Text("아직 오늘의 기록이 없습니다.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("먹은 음식을 기록해보세요.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}

// MARK: - Preview

#Preview {

    ProteinView()
}
