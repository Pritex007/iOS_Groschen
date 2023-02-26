import Foundation

protocol NewOperationModelInput: AnyObject {
    func getCategory() -> String
    func getOperation() -> OperationEntity
    func setCategory(_ category: CategoryEntity)
    func setAmount(_ amount: Decimal)
    func setDate(_ date: Date)
    func setTime(_ time: Date)
    func setComment(_ comment: String)
}

protocol NewOperationModelOutput: AnyObject {
    func categoryChanged(category: String)
    func enoughDataToSave()
    func notEnoughDataToSave()
}
