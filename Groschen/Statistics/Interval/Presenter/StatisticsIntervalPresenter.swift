import Foundation

final class StatisticsIntervalPresenter {
    
    // MARK: Internal properties
    
    weak var view: StatisticsIntervalViewInput?
    weak var output: StatisticsIntervalModuleOutput?
    var model: StatisticsIntervalModelInput?
    
    let configureDataFactory: StatisticsIntervalConfigureDataFactoryProtocol
    
    // MARK: Lifecycle
    
    init(configureDataFactory: StatisticsIntervalConfigureDataFactoryProtocol) {
        self.configureDataFactory = configureDataFactory
    }
}

// MARK: - StatisticsIntervalViewOutput

extension StatisticsIntervalPresenter: StatisticsIntervalViewOutput {
    func userDidTapDoneButton() {
        guard let intervalType = model?.getSelectedIntervalType() else { return }
        let startDate = model?.getStartDate()
        let endDate = model?.getEndDate()
        output?.transferInterval(intervalType, startDate, endDate)
        output?.finish()
    }
    
    func selectedStartDate(_ date: Date) -> Date {
        guard let startDate = model?.getStartDate(),
              let endDate = model?.getEndDate()
        else {
            return Date()
        }
        if (date <= endDate) {
            model?.obtainStartDate(date)
            return date
        } else {
            return startDate
        }
    }
    
    func selectedEndDate(_ date: Date) -> Date {
        guard let startDate = model?.getStartDate(),
              let endDate = model?.getEndDate()
        else {
            return Date()
        }
        if (date >= startDate) {
            model?.obtainEndDate(date)
            return date
        } else {
            return endDate
        }
    }
    
    func selectedIntervalType(_ type: StatisticsIntervalSelectionCell.CellType) {
        guard let oldSelectedIntervalType = model?.getSelectedIntervalType() else {
            model?.obtainSelectedIntervalType(type)
            if type == .custom {
                view?.addCustomIntervalSection()
            }
            return
        }
        
        if oldSelectedIntervalType == type {
            model?.obtainSelectedIntervalType(nil)
            view?.unMarkCell(type.rawValue)
            if oldSelectedIntervalType == .custom {
                view?.deleteCustomIntervalSection()
            }
        } else {
            model?.obtainSelectedIntervalType(type)
            if type == .custom {
                view?.addCustomIntervalSection()
            }
            if oldSelectedIntervalType == .custom {
                view?.deleteCustomIntervalSection()
            }
            view?.unMarkCell(oldSelectedIntervalType.rawValue)
        }
    }
    
    func configureDatePickerCell(type: StatisticsDatePickerCell.CellType) -> StatisticsDatePickerCell.ConfigureData {
        let translateData: (DatePickerCellDataTransferDelegate, Date) -> Date = { _, _ in return Date() }
        switch type {
        case .startDatePicker:
            guard let startDate = model?.getStartDate() else {
                return StatisticsDatePickerCell.ConfigureData(date: Date(), dateChangeAction: translateData)
            }
            return configureDataFactory.configureStartDatePicker(startDate)
        case .endDatePicker:
            guard let endDate = model?.getEndDate() else {
                return StatisticsDatePickerCell.ConfigureData(date: Date(), dateChangeAction: translateData)
            }
            return configureDataFactory.configureEndDatePicker(endDate)
        }
    }
    
    func configureIntervalDateCell(type: StatisticsDateIntervalCell.CellType) -> StatisticsDateIntervalCell.ConfigureData {
        switch type {
        case .start:
            let startDate = model?.getStartDate()
            return configureDataFactory.configureStartDate(startDate ?? Date())
        case .end:
            let endDate = model?.getEndDate()
            return configureDataFactory.configureEndDate(endDate ?? Date())
        }
    }
    
    func configureIntervalSelectionCell(_ type: StatisticsIntervalSelectionCell.CellType) -> StatisticsIntervalSelectionCell.ConfigureData {
        guard let intervalType = model?.getSelectedIntervalType() else {
            return configureDataFactory.configureIntervalSelection(type, false)
        }
        return configureDataFactory.configureIntervalSelection(type, intervalType == type)
    }
    
    func numberOfSections() -> Int {
        guard let intervalType = model?.getSelectedIntervalType() else {
            return 1
        }
        switch intervalType {
        case .month, .year:
            return 1
        case .custom:
            return 2
        }
    }
    
    func numbersOfRow(_ section: Int, _ hasAdditionalRows: Bool) -> Int {
        if section == 0 {
            return 3
        } else {
            return hasAdditionalRows ? 3 : 2
        }
    }
    
    func selectedDateIntervalCell(_ type: StatisticsDateIntervalCell.CellType, _ startDateIsEditing: Bool, _ endDateIsEditing: Bool) {
        switch type {
        case .start:
            if startDateIsEditing {
                view?.deleteStartDatePickerCell()
            } else {
                if endDateIsEditing {
                    view?.deleteEndDatePickerCell()
                }
                view?.addStartDatePickerCell()
            }
        case .end:
            if endDateIsEditing {
                view?.deleteEndDatePickerCell()
            } else {
                if startDateIsEditing {
                    view?.deleteStartDatePickerCell()
                }
                view?.addEndDatePickerCell()
            }
        }
    }
}

extension StatisticsIntervalPresenter: StatisticsIntervalModelOutput {
    func categoryIsSelected() {
        view?.enableDoneButton()
    }
    
    func categoryIsNotSelected() {
        view?.disableDoneButton()
    }
    
    func selectedIntervalTypeChanged(_ type: StatisticsIntervalSelectionCell.CellType) {
        view?.markCell(type.rawValue)
    }
}
