import Foundation

protocol StatisticsIntervalConfigureDataFactoryProtocol {
    func configureStartDatePicker(_ date: Date) -> StatisticsDatePickerCell.ConfigureData
    func configureEndDatePicker(_ date: Date) -> StatisticsDatePickerCell.ConfigureData
    func configureStartDate(_ date: Date) -> StatisticsDateIntervalCell.ConfigureData
    func configureEndDate(_ date: Date) -> StatisticsDateIntervalCell.ConfigureData
    func configureIntervalSelection(_ type: StatisticsIntervalSelectionCell.CellType, _ isMarked: Bool) -> StatisticsIntervalSelectionCell.ConfigureData
}


final class StatisticsIntervalConfigureDataFactory: StatisticsIntervalConfigureDataFactoryProtocol {
    func configureStartDatePicker(_ date: Date) -> StatisticsDatePickerCell.ConfigureData {
        let result = StatisticsDatePickerCell.ConfigureData(date: date) { delegate, newDate in
            return delegate.startDateChanged(newDate)
        }
        return result
    }
    
    func configureEndDatePicker(_ date: Date) -> StatisticsDatePickerCell.ConfigureData {
        let result = StatisticsDatePickerCell.ConfigureData(date: date) { delegate, newDate in
            return delegate.endDateChanged(newDate)
        }
        return result
    }
    
    func configureIntervalSelection(_ type: StatisticsIntervalSelectionCell.CellType, _ isMarked: Bool) -> StatisticsIntervalSelectionCell.ConfigureData {
        var title: String
        switch type {
        case .custom:
            title = "Произвольный"
        case .month:
            title = "Месяц"
        case .year:
            title = "Год"
        }
        return StatisticsIntervalSelectionCell.ConfigureData(title: title, isMarked: isMarked)
    }
    
    func configureStartDate(_ date: Date) -> StatisticsDateIntervalCell.ConfigureData {
        let description = DateFormatter.dayMonthYearFormatter.string(from: date)
        let result = StatisticsDateIntervalCell.ConfigureData(title: "Начало", description: description)
        return result
    }
    
    func configureEndDate(_ date: Date) -> StatisticsDateIntervalCell.ConfigureData {
        let description = DateFormatter.dayMonthYearFormatter.string(from: date)
        let result = StatisticsDateIntervalCell.ConfigureData(title: "Конец", description: description)
        return result
    }
}
