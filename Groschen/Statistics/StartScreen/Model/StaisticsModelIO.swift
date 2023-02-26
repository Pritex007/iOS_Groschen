import Foundation

protocol StatisticsModelInput: AnyObject {
    func obtainIncomeCount(count: Int)
    func obtainExpenseCount(count: Int)
    func obtainIntervalType(type: StatisticsIntervalSelectionCell.CellType)
    func obtainStartDate(date: Date)
    func obtainEndDate(date: Date)
    func addToBalance(amount: Decimal)
    func getIntervalType() -> StatisticsIntervalSelectionCell.CellType
    func getIncomeCount() -> Int
    func getExpenseCount() -> Int
    func getBalance() -> Decimal
    func getStartDate() -> Date
    func getEndDate() -> Date
}

protocol StatisticsModelOutput: AnyObject {
    func dataChanged()
}
