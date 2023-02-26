import Foundation

final class EditOperationModel {
    
    // MARK: - Internal properties
    
    weak var output: EditOperationModelOutput?
    
    // MARK: - Private properties
    
    private var data: OperationEntity = OperationEntity(operationId: UUID().uuidString,
                                                        amount: 0,
                                                        category: CategoryEntity(categoryId: UUID().uuidString, title: "", operationType: .null),
                                                        comment: nil,
                                                        currency: 643,
                                                        dateTime: Date())
    private let defaultData: OperationEntity
    
    // MARK: - Lifecycle
    
    init(operation: OperationEntity) {
        data = operation
        defaultData = operation
    }
    
    // MARK: - Private methods
    
    private func checkOnReadyToSave() {
        if(!data.category.title.isEmpty
            && data.amount != 0
            && (data.amount != defaultData.amount
                    || data.category.title != defaultData.category.title
                    || data.comment != defaultData.comment
                    || data.currency != defaultData.currency
                    || data.dateTime != defaultData.dateTime)
        ) {
            output?.enoughDataToSave()
        } else {
            output?.notEnoughDataToSave()
        }
    }
}

// MARK: - NewOperationModelInput

extension EditOperationModel: EditOperationModelInput {
    func getDefaultOperation() -> OperationEntity {
        return defaultData
    }
    
    func setCategory(_ category: CategoryEntity) {
        data.category = category
        output?.categoryChanged(category: data.category.title)
        checkOnReadyToSave()
    }
    
    func setAmount(_ amount: Decimal) {
        data.amount = amount
        checkOnReadyToSave()
    }
    
    func setDate(_ date: Date) {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let timeComponents = Calendar.current.dateComponents([.minute, .hour], from: data.dateTime)
        
        dateComponents.minute = timeComponents.minute
        dateComponents.hour = timeComponents.hour
        
        data.dateTime = Calendar.current.date(from: dateComponents) ?? Date()
        checkOnReadyToSave()
    }
    
    func setTime(_ time: Date) {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: data.dateTime)
        let timeComponents = Calendar.current.dateComponents([.minute, .hour], from: time)
        
        dateComponents.minute = timeComponents.minute
        dateComponents.hour = timeComponents.hour
        
        data.dateTime = Calendar.current.date(from: dateComponents) ?? Date()
        checkOnReadyToSave()
    }
    
    func setComment(_ comment: String) {
        data.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        checkOnReadyToSave()
    }
    
    func getCategory() -> String {
        return data.category.title
    }
    
    func getOperation() -> OperationEntity {
        return data
    }
    
    func getAmount() -> Decimal {
        return data.amount
    }
    
    func getDate() -> Date {
        return data.dateTime
    }
    
    func getComment() -> String? {
        return data.comment
    }
}
