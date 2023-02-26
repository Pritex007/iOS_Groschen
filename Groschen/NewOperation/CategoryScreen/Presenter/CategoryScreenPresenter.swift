import UIKit

final class CategoryScreenPresenter {
    weak var view: CategoryScreenViewInput?
    var model: CategoryScreenModelInput?
    weak var output: CategoryScreenModuleOutput?
    
    private let operationType: OperationType
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    
    private let displayDataFactory: CategoryScreenDisplayDataFactoryProtocol
    
    init(coreDataManager: CoreDataManagerProtocol,
         storageRequestFactory: FetchRequestFactoryProtocol,
         storage: StorageProtocol,
         operationType: OperationType,
         displayDataFactory: CategoryScreenDisplayDataFactoryProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = storageRequestFactory
        self.storage = storage
        self.operationType = operationType
        self.displayDataFactory = displayDataFactory
    }
}

// MARK: - CategoryScreenModelOutput

extension CategoryScreenPresenter: CategoryScreenModelOutput {
    func categoriesChanged() {
        DispatchQueue.main.async {
            self.view?.reloadTable()
        }
    }
    
    func selectedCategoryChanged(categoryId: String, categoryTitle: String, index: Int?) {
        output?.translateCategory(categoryId: categoryId,
                                  categoryTitle: categoryTitle)
        if let strongIndex = index {
            view?.markCell(strongIndex)
        }
    }
}

// MARK: - CategoryScreenViewOutput

extension CategoryScreenPresenter: CategoryScreenViewOutput {
    func viewWillAppear() {
        storage.obtainCategory(operationType: operationType) { result in
            switch result {
            case .failure(_):
                break
            case .success(let categories):
                self.model?.loadDataInModel(data: categories)
            }
        }
    }
    
    func getNumberOfCategories() -> Int {
        guard let number = model?.getNumberOfCategories() else { return 0 }
        return number
    }
    
    func addNewCategory(categoryTitle: String) {
        let clearCategory = categoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let isUnique = model?.checkCategoryOnUnique(categoryTitle: clearCategory),
              isUnique, !clearCategory.isEmpty else { return }
        storage.saveCategory(category: CategoryEntity(categoryId: UUID().uuidString,
                                                      title: clearCategory,
                                                      operationType: operationType)) { result in
            switch result {
            case .failure(_):
                break
            case .success(let category):
                self.model?.addNewCategory(category: category)
            }
        }
    }
    
    func configurCell(index: Int) -> CategoryScreenCell.DisplayData {
        guard let title = model?.getCategoryTitle(index: index)
        else {
            return displayDataFactory.categoryDisplayData("", false)
        }
        
        if let selectedIndex = model?.getSelectedCategoryIndex() {
            return displayDataFactory.categoryDisplayData(title, index == selectedIndex)
        }
        
        return displayDataFactory.categoryDisplayData(title, false)
    }
    
    func getSelectedCategoryTitle() -> String {
        guard let result = model?.getSelectedCategoryTitle() else { return "" }
        return result
    }
    
    func userSelectedCategory(categoryIndex: Int) {
        guard let result = model?.getSelectedCategoryIndex() else {
            model?.changeSelectedCategory(index: categoryIndex)
            return
        }
        if result == categoryIndex {
            model?.changeSelectedCategory(index: nil)
            view?.unmarkCell(result)
        } else {
            model?.changeSelectedCategory(index: categoryIndex)
            view?.unmarkCell(result)
        }
    }
}
