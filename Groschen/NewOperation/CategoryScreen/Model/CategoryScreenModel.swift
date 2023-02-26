import Foundation

final class CategoryScreenModel {
    weak var output: CategoryScreenModelOutput?
    
    private var data: [CategoryEntity] = []
    private var selectedCategoryTitle: String?
    
    func setStartSelectedCategoryTitle(title: String?) {
        selectedCategoryTitle = title
    }
}

// MARK: - CategoryScreenModelInput

extension CategoryScreenModel: CategoryScreenModelInput {
    func getCategoryTitle(index: Int) -> String {
        return data[index].title
    }
    
    func getSelectedCategoryIndex() -> Int? {
        guard let strongSelectedCategory = selectedCategoryTitle else { return  nil }
        return data.firstIndex { entity -> Bool in
            entity.title == strongSelectedCategory
        }
    }
    
    func getSelectedCategoryTitle() -> String? {
        return selectedCategoryTitle
    }
    
    func changeSelectedCategory(index: Int?) {
        guard let strongIndex = index else {
            selectedCategoryTitle = nil
            output?.selectedCategoryChanged(categoryId: UUID().uuidString, categoryTitle: "", index: nil)
            return
        }
        selectedCategoryTitle = data[strongIndex].title
        output?.selectedCategoryChanged(categoryId: data[strongIndex].categoryId,
                                        categoryTitle: data[strongIndex].title,
                                        index: strongIndex)
    }
    
    func getNumberOfCategories() -> Int {
        return data.count
    }
    
    func addNewCategory(category: CategoryEntity) {
        data.append(category)
        output?.categoriesChanged()
    }
    
    func loadDataInModel(data: [CategoryEntity]) {
        self.data = data
        output?.categoriesChanged()
    }
    
    func checkCategoryOnUnique(categoryTitle: String) -> Bool {
        let isUnique = !data.contains(where: { element -> Bool in
            return element.title.lowercased() == categoryTitle.lowercased()
        })
        
        return isUnique
    }
}
