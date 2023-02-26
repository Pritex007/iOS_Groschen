import Foundation

struct OperationEntity {
    var operationId: String
    var amount: Decimal
    var category: CategoryEntity
    var comment: String?
    var currency: Int32
    var dateTime: Date
}
