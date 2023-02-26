import Foundation

protocol IncomeViewInput: AnyObject {
    func reloadTable()
}

protocol IncomeViewOutput: AnyObject {
    func viewWillAppear()
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationCell.DisplayData
    func configureSectionHeader(index: Int) -> (date: String, amount: AmountView.DisplayData)
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
    func addNewIncome()
    func userDidSelectIncomeCell(at indexPath: IndexPath)
}
