import Foundation

protocol StatisticsIntervalViewInput: AnyObject {
    func markCell(_ index: Int)
    func unMarkCell(_ index: Int)
    func addCustomIntervalSection()
    func addStartDatePickerCell()
    func addEndDatePickerCell()
    func deleteCustomIntervalSection()
    func deleteStartDatePickerCell()
    func deleteEndDatePickerCell()
    func enableDoneButton()
    func disableDoneButton()
}

protocol StatisticsIntervalViewOutput: AnyObject {
    func configureDatePickerCell(type: StatisticsDatePickerCell.CellType) -> StatisticsDatePickerCell.ConfigureData
    func configureIntervalDateCell(type: StatisticsDateIntervalCell.CellType) -> StatisticsDateIntervalCell.ConfigureData
    func configureIntervalSelectionCell(_ type: StatisticsIntervalSelectionCell.CellType) -> StatisticsIntervalSelectionCell.ConfigureData
    func selectedIntervalType(_ type: StatisticsIntervalSelectionCell.CellType)
    func selectedDateIntervalCell(_ type: StatisticsDateIntervalCell.CellType, _ startDateIsEditing: Bool, _ endDateIsEditing: Bool)
    func userDidTapDoneButton()
    func numberOfSections() -> Int
    func numbersOfRow(_ section: Int, _ hasAdditionalRows: Bool) -> Int
    
    // Returns previous right start date of DatePicker
    @discardableResult
    func selectedStartDate(_ date: Date) -> Date
    
    // Returns previous right end date of DatePicker
    @discardableResult
    func selectedEndDate(_ date: Date) -> Date
}
