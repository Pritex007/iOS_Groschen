import UIKit

final class NewOperationBuilder {
    func build(output: NewOperationModuleOutput, operationType: OperationType) -> (view: UIViewController, moduleInput: NewOperationModuleInput) {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        
        let configureDataFactory = NewOperationConfigureDataFactory()
        
        let view = NewOperationViewController()
        let presenter = NewOperationPresenter(coreDataManager: coreDataManager,
                                              storageRequestFactory: storageRequestFactory,
                                              storage: storage,
                                              configureDataFactory: configureDataFactory)
        let model = NewOperationModel()
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        presenter.operationType = operationType
        
        view.output = presenter
        
        model.output = presenter
        
        return (view: view, moduleInput: presenter)
    }
}
