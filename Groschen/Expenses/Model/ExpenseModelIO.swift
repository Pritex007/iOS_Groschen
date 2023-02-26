import Foundation

protocol ExpenseModelInput: AnyObject {
    func loadData(data: [OperationSectionData])
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity
    func configureSectionHeader(index: Int) -> OperationSectionData
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
}

protocol ExpenseModelOutput: AnyObject {
    func dataChanged()
}
