import Foundation

protocol CategoryScreenModuleOutput: AnyObject {
    func translateCategory(categoryId: String, categoryTitle: String)
}
