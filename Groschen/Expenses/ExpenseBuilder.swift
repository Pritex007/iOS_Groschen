import UIKit

final class ExpenseBuilder {
    func build(output: ExpenseModuleOutput) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        let displayDataFactory = OperationDisplayDataFactory()
        
        let view = ExpenseViewController()
        let presenter = ExpensePresenter(coreDataManager: coreDataManager,
                                         storageRequestFactory: storageRequestFactory,
                                         displayDataFactory: displayDataFactory,
                                         storage: storage)
        let model = ExpenseModel()
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        
        view.output = presenter
        
        model.output = presenter
        
        return view
    }
}
