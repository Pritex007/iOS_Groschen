import UIKit

final class StatisticsIntervalBuilder {
    func build(output: StatisticsIntervalModuleOutput, _ type: StatisticsIntervalSelectionCell.CellType?, _ startDate: Date?, _ endDate: Date?) -> UIViewController {
        let configureDataFactory = StatisticsIntervalConfigureDataFactory()
        
        let view = StatisticsIntervalViewController()
        let presenter = StatisticsIntervalPresenter(configureDataFactory: configureDataFactory)
        let model = StatisticsIntervalModel()
        
        presenter.view = view
        presenter.model = model
        presenter.output = output
        
        view.output = presenter
        
        model.output = presenter
        model.obtainSelectedIntervalType(type)
        
        if let startDate = startDate {
            model.obtainStartDate(startDate)
        }
        
        if let startDate = endDate {
            model.obtainEndDate(startDate)
        }
        
        return view
    }
}
