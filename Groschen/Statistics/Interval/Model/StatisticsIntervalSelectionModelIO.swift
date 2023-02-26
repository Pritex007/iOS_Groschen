import Foundation

protocol StatisticsIntervalModelInput: AnyObject {
    func obtainStartDate(_ date: Date)
    func obtainEndDate(_ date: Date)
    func obtainSelectedIntervalType(_ type: StatisticsIntervalSelectionCell.CellType?)
    func getSelectedIntervalType() -> StatisticsIntervalSelectionCell.CellType?
    func getStartDate() -> Date
    func getEndDate() -> Date
}

protocol StatisticsIntervalModelOutput: AnyObject {
    func selectedIntervalTypeChanged(_ type: StatisticsIntervalSelectionCell.CellType)
    func categoryIsSelected()
    func categoryIsNotSelected()
}
