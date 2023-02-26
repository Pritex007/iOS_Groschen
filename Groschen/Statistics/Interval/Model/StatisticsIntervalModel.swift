import Foundation

final class StatisticsIntervalModel {
    
    // MARK: Internal properties
    
    weak var output: StatisticsIntervalModelOutput?
    
    // MARK: Private properties
    
    private var intervalType: StatisticsIntervalSelectionCell.CellType?
    private var startDate: Date = Date()
    private var endDate: Date = Date()
}

// MARK: - StatisticsIntervalModelInput

extension StatisticsIntervalModel: StatisticsIntervalModelInput {
    func obtainStartDate(_ date: Date) {
        startDate = date
    }
    
    func obtainEndDate(_ date: Date) {
        endDate = date
    }
    
    func obtainSelectedIntervalType(_ type: StatisticsIntervalSelectionCell.CellType?) {
        if let type = type {
            output?.selectedIntervalTypeChanged(type)
            if intervalType == nil {
                output?.categoryIsSelected()
            }
        } else {
            output?.categoryIsNotSelected()
        }
        intervalType = type
    }
    
    func getSelectedIntervalType() -> StatisticsIntervalSelectionCell.CellType? {
        return intervalType
    }
    
    func getStartDate() -> Date {
        return startDate
    }
    
    func getEndDate() -> Date {
        return endDate
    }
}
