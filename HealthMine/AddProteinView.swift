import SwiftUI

struct AddProteinView: View {

    @ObservedObject var proteinManager: ProteinManager

    @Environment(\.dismiss) private var dismiss

    @State private var foodName = ""
    @State private var proteinAmount = ""

    var body: some View {

        NavigationStack {

            Form {

                Section("음식") {

                    TextField(
                        "예: 닭가슴살",
                        text: $foodName
                    )
                }

                Section("단백질") {

                    HStack {

                        TextField(
                            "단백질 양",
                            text: $proteinAmount
                        )
                        .keyboardType(.decimalPad)

                        Text("g")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {

                    Button("기록하기") {

                        guard
                            !foodName.isEmpty,
                            let protein = Double(
                                proteinAmount
                            )
                        else {
                            return
                        }

                        proteinManager.addRecord(
                            foodName: foodName,
                            protein: protein
                        )

                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("단백질 기록")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
