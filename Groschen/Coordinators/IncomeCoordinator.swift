import UIKit

final class IncomeCoordinator {
    
    // MARK: - Internal properties
    
    weak var editOperationModuleInput: EditOperationModuleInput?
    
    private let navigationController: UINavigationController
    private var childCoordinators: CoordinatorProtocol?
    
    init(tabBar: UITabBarController) {
        navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem.init(title: "Доходы",
                                                            image: UIImage(systemName: "plus.circle",
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

extension IncomeCoordinator: CoordinatorProtocol {
    func start() {
        let incomeBuilder = IncomeBuilder()
        let viewController = incomeBuilder.build(output: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}

// MARK: - IncomeCoordinatorInput

extension IncomeCoordinator: IncomeModuleOutput {
    func incomeModuleWantsToOpenEditOperationScreen(operation: OperationEntity) {
        let editIncomeBuilder = EditOperationBuilder()
        let (view: viewController, moduleInput: moduleInput) = editIncomeBuilder.build(output: self, operationType: .income, operation: operation)
        editOperationModuleInput = moduleInput
        viewController.title = "Новый доход"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func incomeModuleWantsToOpenNewIncomeScreen() {
        childCoordinators = NewIncomeCoordinator(navigationController: navigationController)
        childCoordinators?.start()
    }
}

// MARK: - CategoryScreenModuleOutput

extension IncomeCoordinator: CategoryScreenModuleOutput {
    func translateCategory(categoryId: String, categoryTitle: String) {
        editOperationModuleInput?.setSelectedCategory(categoryId: categoryId, categoryTitle: categoryTitle)
    }
}

// MARK: - EditOperationModuleOutput

extension IncomeCoordinator: EditOperationModuleOutput {
    func editOperationModuleWantsToOpenCategoryScreen(selectedCategory: String?, operationType: OperationType) {
        let categoryBuilder = CategoryScreenBuilder()
        let viewController = categoryBuilder.build(output: self, operationType: operationType, selectedCategory: selectedCategory)
        viewController.title = "Категории"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func editOperationModuleWantsToFinish() {
        DispatchQueue.main.async {
            self.navigationController.popToRootViewController(animated: true)
        }
    }
}
