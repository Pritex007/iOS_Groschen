import Foundation

protocol EditOperationModelInput: AnyObject {
    func getCategory() -> String
    func getOperation() -> OperationEntity
    func getAmount() -> Decimal
    func getDate() -> Date
    func getComment() -> String?
    func getDefaultOperation() -> OperationEntity
    func setCategory(_ category: CategoryEntity)
    func setAmount(_ amount: Decimal)
    func setDate(_ date: Date)
    func setTime(_ time: Date)
    func setComment(_ comment: String)
}

protocol EditOperationModelOutput: AnyObject {
    func categoryChanged(category: String)
    func enoughDataToSave()
    func notEnoughDataToSave()
}
