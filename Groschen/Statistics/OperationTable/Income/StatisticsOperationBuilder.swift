import UIKit

final class StatisticsOperationBuilder {
    func build(type: StatisticsIntervalSelectionCell.CellType, startDate: Date?, endDate: Date?) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let storageRequestFactory = FetchRequestFactory()
        let storage = Storage(coreDataManager: coreDataManager, storageRequestFactory: storageRequestFactory)
        let displayDataFactory = OperationDisplayDataFactory()
        
        let view = StatisticsOperationViewController()
        let presenter = StatisticsOperationPresenter(coreDataManager: coreDataManager,
                                                     storageRequestFactory: storageRequestFactory,
                                                     displayDataFactory: displayDataFactory,
                                                     storage: storage)
        let model = StatisticsOperationModel()
        
        presenter.view = view
        presenter.model = model
        
        view.output = presenter
        
        model.output = presenter
        model.setIntervalInfo(type, startDate, endDate)
        
        return view
    }
}
