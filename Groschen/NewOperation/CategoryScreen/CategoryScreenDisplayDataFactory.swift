import Foundation

protocol CategoryScreenDisplayDataFactoryProtocol {
    func categoryDisplayData(_ title: String, _ isMarked: Bool) -> CategoryScreenCell.DisplayData
}

final class CategoryScreenDisplayDataFactory: CategoryScreenDisplayDataFactoryProtocol {
    func categoryDisplayData(_ title: String, _ isMarked: Bool) -> CategoryScreenCell.DisplayData {
        return CategoryScreenCell.DisplayData(title: title, marked: isMarked)
    }
}
