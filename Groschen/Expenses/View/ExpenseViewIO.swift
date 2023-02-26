import Foundation

protocol ExpenseViewInput: AnyObject {
    func reloadTable()
}

protocol ExpenseViewOutput: AnyObject {
    func viewWillAppear()
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationCell.DisplayData
    func configureSectionHeader(index: Int) -> OperationSectionHeader.DisplayData
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
    func addNewExpense()
    func userDidSelectExpenseCell(at indexPath: IndexPath)
}
