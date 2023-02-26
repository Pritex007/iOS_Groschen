import Foundation

protocol StatisticsIntervalModuleOutput: AnyObject {
    func finish()
    func transferInterval(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}
