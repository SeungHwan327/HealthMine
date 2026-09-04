import Foundation
import Combine

final class ProteinManager: ObservableObject {

    @Published var records: [ProteinRecord] = []

    private let recordsKey = "proteinRecords"

    init() {
        loadRecords()
    }

    // MARK: - 오늘 섭취량

    var todayProtein: Double {
        let calendar = Calendar.current

        return records
            .filter {
                calendar.isDateInToday($0.date)
            }
            .reduce(0) {
                $0 + $1.protein
            }
    }

    // MARK: - 특정 날짜의 단백질

    func protein(for date: Date) -> Double {

        let calendar = Calendar.current

        return records
            .filter {
                calendar.isDate(
                    $0.date,
                    inSameDayAs: date
                )
            }
            .reduce(0) {
                $0 + $1.protein
            }
    }

    // MARK: - 기록 추가

    func addRecord(
        foodName: String,
        protein: Double
    ) {

        let record = ProteinRecord(
            foodName: foodName,
            protein: protein
        )

        records.append(record)

        saveRecords()
    }

    // MARK: - 기록 삭제

    func deleteRecord(
        _ record: ProteinRecord
    ) {

        records.removeAll {
            $0.id == record.id
        }

        saveRecords()
    }

    // MARK: - 저장

    private func saveRecords() {

        do {

            let data = try JSONEncoder().encode(records)

            UserDefaults.standard.set(
                data,
                forKey: recordsKey
            )

        } catch {

            print("단백질 기록 저장 실패: \(error)")
        }
    }

    // MARK: - 불러오기

    private func loadRecords() {

        guard let data = UserDefaults.standard.data(
            forKey: recordsKey
        ) else {
            return
        }

        do {

            records = try JSONDecoder().decode(
                [ProteinRecord].self,
                from: data
            )

        } catch {

            print("단백질 기록 불러오기 실패: \(error)")
        }
    }
}
