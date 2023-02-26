import UIKit

final class CategoryScreenBuilder {
    func build(output: CategoryScreenModuleOutput, operationType: OperationType, selectedCategory: String?) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        
        let displayDataFactory = CategoryScreenDisplayDataFactory()
        
        let view = CategoryScreenViewController()
        let presenter = CategoryScreenPresenter(coreDataManager: coreDataManager,
                                                storageRequestFactory: storageRequestFactory,
                                                storage: storage,
                                                operationType: operationType,
                                                displayDataFactory: displayDataFactory)
        let model = CategoryScreenModel()
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        
        view.output = presenter
        
        model.output = presenter
        model.setStartSelectedCategoryTitle(title: selectedCategory)
        
        return view
    }
}
