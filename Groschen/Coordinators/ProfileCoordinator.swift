import UIKit

final class ProfileCoordinator {
    
    private let navigationController: UINavigationController
    
    init(tabBar: UITabBarController) {
        navigationController = UINavigationController()
        navigationController.tabBarItem = .init(title: "Профиль", image: UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration.init(weight: .regular)), selectedImage: nil)
        tabBar.addChild(navigationController)
    }
}
    
// MARK: - CoordinatorProtocol
    
extension ProfileCoordinator: CoordinatorProtocol {
    func start() {
        let profileBuilder = ProfileBuilder()
        let viewController = profileBuilder.build(coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}
