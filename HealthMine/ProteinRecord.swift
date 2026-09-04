import Foundation

struct ProteinRecord: Identifiable, Codable {
    let id: UUID
    var foodName: String
    var protein: Double
    var date: Date

    init(
        id: UUID = UUID(),
        foodName: String,
        protein: Double,
        date: Date = Date()
    ) {
        self.id = id
        self.foodName = foodName
        self.protein = protein
        self.date = date
    }
}
