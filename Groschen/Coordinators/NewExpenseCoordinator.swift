import UIKit

final class NewExpenseCoordinator {
    weak var moduleInput: NewOperationModuleInput?
    
    private let navigationController: UINavigationController
    private var childCoordinator: CoordinatorProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - CoordinatorProtocol

extension NewExpenseCoordinator: CoordinatorProtocol {
    func start() {
        let newExpenseBuilder = NewOperationBuilder()
        let (viewController, moduleInput) = newExpenseBuilder.build(output: self, operationType: .expense)
        self.moduleInput = moduleInput
        viewController.title = "Новый расход"
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - NewExpenseCoordinatorInput

extension NewExpenseCoordinator: NewOperationModuleOutput {
    func openCategoryScreen(selectedCategory: String?) {
        let categoryBuilder = CategoryScreenBuilder()
        let viewController = categoryBuilder.build(output: self, operationType: .expense, selectedCategory: selectedCategory)
        viewController.title = "Категории"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - CategoryScreenModuleOutput

extension NewExpenseCoordinator: CategoryScreenModuleOutput {
    func translateCategory(categoryId: String,
                           categoryTitle: String) {
        moduleInput?.obtainSelectedCategory(categoryId: categoryId,
                                            categoryTitle: categoryTitle)
    }
}
