import Foundation

enum OperationType: Int16 {
    case null = 0
    case income = 1
    case expense = 2
}

struct CategoryEntity {
    let categoryId: String
    var title: String
    var operationType: OperationType
}
