import Foundation

protocol EditOperationModuleOutput: AnyObject {
    func editOperationModuleWantsToOpenCategoryScreen(selectedCategory: String?, operationType: OperationType)
    func editOperationModuleWantsToFinish()
}

protocol EditOperationModuleInput: AnyObject {
    func setSelectedCategory(categoryId: String, categoryTitle: String)
}
