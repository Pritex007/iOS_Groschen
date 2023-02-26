import Foundation

protocol StatisticsModuleOutput: AnyObject {
    func openIncomeScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
    func openExpenseScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
    func openBalanceScreen()
    func openIntervalSelectionScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}

protocol StatisticsModuleInput: AnyObject {
    func obtainInterval(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}
