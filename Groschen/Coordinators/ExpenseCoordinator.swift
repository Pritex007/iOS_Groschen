import UIKit

final class ExpenseCoordinator {
    
    // MARK: - Internal properties
    
    weak var moduleInput: EditOperationModuleInput?
    
    private let navigationController: UINavigationController
    private var childCoordinators: CoordinatorProtocol?
    
    init(tabBar: UITabBarController) {
        navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem.init(title: "Расходы",
                                                            image: UIImage(systemName: "minus.circle",
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

extension ExpenseCoordinator: CoordinatorProtocol {
    func start() {
        let expenseBuilder = ExpenseBuilder()
        let viewController = expenseBuilder.build(output: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}

// MARK: - ExpenseCoordinatorInput

extension ExpenseCoordinator: ExpenseModuleOutput {
    func expenseModuleWantsToOpenEditOperationScreen(operation: OperationEntity) {
        let editExpenseBuilder = EditOperationBuilder()
        let (viewController, moduleInput) = editExpenseBuilder.build(output: self, operationType: .expense, operation: operation)
        self.moduleInput = moduleInput
        viewController.title = "Новый расход"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func expenseModuleWantsToOpenNewExpenseScreen() {
        childCoordinators = NewExpenseCoordinator(navigationController: navigationController)
        childCoordinators?.start()
    }
}

// MARK: - CategoryScreenModuleOutput

extension ExpenseCoordinator: CategoryScreenModuleOutput {
    func translateCategory(categoryId: String, categoryTitle: String) {
        moduleInput?.setSelectedCategory(categoryId: categoryId, categoryTitle: categoryTitle)
    }
}

// MARK: - EditOperationModuleOutput

extension ExpenseCoordinator: EditOperationModuleOutput {
    func editOperationModuleWantsToOpenCategoryScreen(selectedCategory: String?, operationType: OperationType) {
        let categoryBuilder = CategoryScreenBuilder()
        let viewController = categoryBuilder.build(output: self, operationType: operationType, selectedCategory: selectedCategory)
        viewController.title = "Категории"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func editOperationModuleWantsToFinish() {
        navigationController.popToRootViewController(animated: true)
    }
}
