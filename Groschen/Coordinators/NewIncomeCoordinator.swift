import UIKit

final class NewIncomeCoordinator {
    weak var moduleInput: NewOperationModuleInput?
    
    private let navigationController: UINavigationController
    private var childCoordinator: CoordinatorProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - CoordinatorProtocol

extension NewIncomeCoordinator: CoordinatorProtocol {
    func start() {
        let newIncomeBuilder = NewOperationBuilder()
        let (viewController, moduleInput) = newIncomeBuilder.build(output: self, operationType: .income)
        self.moduleInput = moduleInput
        viewController.title = "Новый доход"
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - NewIncomeCoordinatorInput

extension NewIncomeCoordinator: NewOperationModuleOutput {
    func openCategoryScreen(selectedCategory: String?) {
        let categoryBuilder = CategoryScreenBuilder()
        let viewController = categoryBuilder.build(output: self, operationType: .income, selectedCategory: selectedCategory)
        viewController.title = "Категории"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        self.navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - CategoryScreenModuleOutput

extension NewIncomeCoordinator: CategoryScreenModuleOutput {
    func translateCategory(categoryId: String,
                           categoryTitle: String) {
        moduleInput?.obtainSelectedCategory(categoryId: categoryId,
                                                   categoryTitle: categoryTitle)
    }
}
