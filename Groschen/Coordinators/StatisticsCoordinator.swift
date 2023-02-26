import UIKit

final class StatisticsCoordinator {
    
    private let navigationController: UINavigationController
    
    weak var moduleInput: StatisticsModuleInput?
    
    init(tabBar: UITabBarController) {
        navigationController = UINavigationController()
        navigationController.tabBarItem = .init(title: "Статистика",
                                                image: UIImage(systemName: "chart.bar",
                                                               withConfiguration: UIImage.SymbolConfiguration.init(weight: .regular)),
                                                selectedImage: nil)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        navigationController.navigationBar.tintColor = .label
        
        tabBar.addChild(navigationController)
    }
}

// MARK: - CoordinatorProtocol

extension StatisticsCoordinator: CoordinatorProtocol {
    func start() {
        let statisticsBuilder = StatisticsBuilder()
        let (viewController, moduleInput) = statisticsBuilder.build(output: self)
        self.moduleInput = moduleInput
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension StatisticsCoordinator: StatisticsModuleOutput {
    func openIntervalSelectionScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        let builder = StatisticsIntervalBuilder()
        let viewController = builder.build(output: self, type, startDate, endDate)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openIncomeScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        let statisticsOperationBuilder = StatisticsOperationBuilder()
        let viewController = statisticsOperationBuilder.build(type: type, startDate: startDate, endDate: endDate)
        viewController.title = "Доход"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openExpenseScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        let statisticsOperationBuilder = StatisticsOperationBuilder()
        let viewController = statisticsOperationBuilder.build(type: type, startDate: startDate, endDate: endDate)
        viewController.title = "Расход"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openBalanceScreen() {
    }
}

// MARK: - StatisticsOperationCoordinatorInput

extension StatisticsCoordinator: StatisticsIntervalModuleOutput {
    func transferInterval(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        moduleInput?.obtainInterval(type, startDate, endDate)
    }
    
    func finish() {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
        }
    }
}
