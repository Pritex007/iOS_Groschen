import Foundation

protocol StatisticsOperationModuleOutput: AnyObject {
    func openIntervalSelectionScreen(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}

protocol StatisticsOperationModuleInput: AnyObject {
    func obtainInterval(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?)
}
