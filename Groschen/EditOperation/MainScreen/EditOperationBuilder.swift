import UIKit

final class EditOperationBuilder {
    func build(output: EditOperationModuleOutput, operationType: OperationType, operation: OperationEntity) -> (view: UIViewController, moduleInput: EditOperationModuleInput) {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        
        let configureDataFactory = EditOperationConfigureDataFactory()
        
        let view = EditOperationViewController()
        let presenter = EditOperationPresenter(coreDataManager: coreDataManager,
                                               storageRequestFactory: storageRequestFactory,
                                               storage: storage,
                                               configureDataFactory: configureDataFactory)
        let model = EditOperationModel(operation: operation)
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        presenter.operationType = operationType
        
        view.output = presenter
        
        model.output = presenter
        
        return (view: view, moduleInput: presenter)
    }
}
