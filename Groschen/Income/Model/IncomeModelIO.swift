import Foundation

protocol IncomeModelInput: AnyObject {
    func loadDataInModel(data: [(cellInfo: [OperationEntity], totalAmount: Decimal)])
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity
    func configureSectionHeader(index: Int) -> (date: String, totalAmount: Decimal)
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
}

protocol IncomeModelOutput: AnyObject {
    func reloadDataInView()
}
