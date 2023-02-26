import CoreData

extension OperationModel {
    static func convert(dto: OperationEntity, into context: NSManagedObjectContext) -> OperationModel {
        let model = OperationModel(context: context)
        model.amount = NSDecimalNumber(decimal: dto.amount)
        model.comment = dto.comment
        model.currency = dto.currency
        model.dateTime = dto.dateTime
        model.operationId = dto.operationId
        
        return model
    }
    
    //FIX
    func convertToDTO() -> OperationEntity {
        var categoryDefault = CategoryEntity(categoryId: UUID().uuidString,
                                             title: "",
                                             operationType: .null)
        if category == nil {
            if amount?.decimalValue ?? 0 > 0 {
                categoryDefault.title = "Доход"
                categoryDefault.operationType = .income
            } else {
                categoryDefault.title = "Расход"
                categoryDefault.operationType = .expense
            }
        }
        return OperationEntity(operationId: operationId ?? UUID().uuidString,
                               amount: amount?.decimalValue ?? 0,
                               category: category?.convertToDTO() ?? categoryDefault,
                               comment: comment,
                               currency: currency,
                               dateTime: dateTime ?? Date())
    }
    
    /// Copy without category
    func copy(_ entity: OperationEntity) {
        amount = NSDecimalNumber(decimal: entity.amount)
        comment = entity.comment
        currency = entity.currency
        dateTime = entity.dateTime
    }
}
