import Foundation

protocol StatisticsOperationModelInput: AnyObject {
    func loadDataInModel(data: [(cellInfo: [OperationEntity], totalAmount: Decimal)])
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity
    func configureSectionHeader(index: Int) -> String
    func getNumberOfCellsInSection(index: Int) -> Int
    func getNumberOfSections() -> Int
    func getStartDate() -> Date?
    func getEndDate() -> Date?
    func getIntervalType() -> StatisticsIntervalSelectionCell.CellType
    func setIntervalInfo(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}

protocol StatisticsOperationModelOutput: AnyObject {
    func dataChanged()
}
