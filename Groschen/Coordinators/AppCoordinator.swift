import UIKit

final class AppCoordinator {

    private let tabBarController: UITabBarController
    private var childCoordinators: [CoordinatorProtocol] = []

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
}

// MARK: - CoordinatorProtocol
    
extension AppCoordinator: CoordinatorProtocol {
    func start() {
        
        let expensesCoordinator = ExpenseCoordinator(tabBar: tabBarController)
        let incomeCoordinator = IncomeCoordinator(tabBar: tabBarController)
        let statisticsCoordinator = StatisticsCoordinator(tabBar: tabBarController)
        let profileCoordinator = ProfileCoordinator(tabBar: tabBarController)
        
        childCoordinators = [expensesCoordinator, incomeCoordinator, statisticsCoordinator, profileCoordinator]
        
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }
}
