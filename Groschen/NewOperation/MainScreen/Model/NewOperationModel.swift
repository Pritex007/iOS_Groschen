import Foundation

final class NewOperationModel {
    enum CellType: Int, CaseIterable {
        case amount = 0
        case category = 1
        case dateTime = 2
        case date = 3
        case comment = 4
    }
    
    weak var output: NewOperationPresenter?
    
    private var data: OperationEntity = OperationEntity(operationId: UUID().uuidString,
                                                        amount: 0,
                                                        category: CategoryEntity(categoryId: UUID().uuidString,
                                                                                 title: "",
                                                                                 operationType: .null),
                                                        comment: nil,
                                                        currency: 643,
                                                        dateTime: Date())
    
    private func checkOnReadyToSave() {
        if(!self.data.category.title.isEmpty && self.data.amount != 0) {
            output?.enoughDataToSave()
        } else {
            output?.notEnoughDataToSave()
        }
    }
}

// MARK: - NewOperationModelInput

extension NewOperationModel: NewOperationModelInput {
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
    }
    
    func setTime(_ time: Date) {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: data.dateTime)
        let timeComponents = Calendar.current.dateComponents([.minute, .hour], from: time)
        
        dateComponents.minute = timeComponents.minute
        dateComponents.hour = timeComponents.hour
        
        data.dateTime = Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func setComment(_ comment: String) {
        data.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getCategory() -> String {
        return data.category.title
    }
    
    func getOperation() -> OperationEntity {
        return data
    }
}
