import CoreData

extension CategoryModel {
    @discardableResult
    static func convert(dto: CategoryEntity, into context: NSManagedObjectContext) -> CategoryModel {
        let model = CategoryModel(context: context)
        model.title = dto.title
        model.operationType = dto.operationType.rawValue
        model.categoryId = dto.categoryId
        return model
    }
    
    func convertToDTO() -> CategoryEntity {
        return CategoryEntity(categoryId: categoryId ?? UUID().uuidString,
                              title: title ?? "",
                              operationType: OperationType(rawValue: operationType) ?? OperationType.null)
    }
}
