import Foundation

protocol CategoryScreenModelInput: AnyObject {
    func loadDataInModel(data: [CategoryEntity])
    func addNewCategory(category: CategoryEntity)
    func getNumberOfCategories() -> Int
    func getCategoryTitle(index: Int) -> String
    func changeSelectedCategory(index: Int?)
    func getSelectedCategoryIndex() -> Int?
    func checkCategoryOnUnique(categoryTitle: String) -> Bool
    func getSelectedCategoryTitle() -> String?
}

protocol CategoryScreenModelOutput: AnyObject {
    func categoriesChanged()
    func selectedCategoryChanged(categoryId: String, categoryTitle: String, index: Int?)
}
