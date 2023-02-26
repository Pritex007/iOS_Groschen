import UIKit

final class StatisticsBuilder {
    func build(output: StatisticsModuleOutput) -> (view: UIViewController, moduleInput: StatisticsModuleInput) {
        let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
        let storageRequestFactory: FetchRequestFactoryProtocol = FetchRequestFactory()
        let storage: StorageProtocol = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        
        let configureDataFactory: StatisticsConfigureDataFactoryProtocol = StatisticsConfigureDataFactory()
        
        let view = StatisticsViewController()
        let presenter = StatisticsPresenter(coreDataManager: coreDataManager,
                                            storageRequestFactory: storageRequestFactory,
                                            storage: storage,
                                            configureDataFactory: configureDataFactory)
        let model = StatisticsModel()
        
        presenter.view = view
        presenter.output = output
        presenter.model = model
        
        view.output = presenter
        
        model.output = presenter
        
        return (view, presenter)
    }
}
