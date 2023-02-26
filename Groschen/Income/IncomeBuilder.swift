import UIKit

final class IncomeBuilder {
    func build(output: IncomeModuleOutput) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        let displayDataFactory = OperationDisplayDataFactory()
        
        let view = IncomeViewController()
        let presenter = IncomePresenter(coreDataManager: coreDataManager,
                                        storageRequestFactory: storageRequestFactory,
                                        displayDataFactory: displayDataFactory,
                                        storage: storage)
        let model = IncomeModel()
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        
        view.output = presenter
        
        model.output = presenter
        
        return view
    }
}
