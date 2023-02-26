import Foundation

protocol NewOperationModuleOutput: AnyObject {
    func openCategoryScreen(selectedCategory: String?)
    func finish()
}

protocol NewOperationModuleInput: AnyObject {
    func obtainSelectedCategory(categoryId: String, categoryTitle: String)
}
