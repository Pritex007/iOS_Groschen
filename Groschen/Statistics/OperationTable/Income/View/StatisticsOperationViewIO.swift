import Foundation

protocol StatisticsOperationViewInput: AnyObject {
    func reloadTable()
}

protocol StatisticsOperationViewOutput: AnyObject {
    func viewWillAppear()
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationCell.DisplayData
    func configureSectionHeader(index: Int) -> StatisticsOperationSectionHeader.DisplayData
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
}
