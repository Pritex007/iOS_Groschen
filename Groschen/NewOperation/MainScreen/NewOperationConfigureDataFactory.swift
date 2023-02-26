import Foundation
import UIKit


protocol NewOperationConfigureDataFactoryProtocol {
    func categoryCellConfigureData(description: String?) -> SelectionCell.ConfigureData
    func datePickerCellConfigureData() -> NewOperationDatePickerCell.ConfigureData
    func timePickerCellConfigureData() -> NewOperationDatePickerCell.ConfigureData
    func amountCellConfigureString(operationType: OperationType) -> AmountFieldCell.ConfigureData
}

final class NewOperationConfigureDataFactory: NewOperationConfigureDataFactoryProtocol {
    
    // MARK: - Private constants
    
    enum Constants {
        struct ToolBar {
            static let height: CGFloat = 50
        }
    }
    
    // MARK: - Internal methods
    
    func amountCellConfigureString(operationType: OperationType) -> AmountFieldCell.ConfigureData {
        switch operationType {
        case .income:
            return AmountFieldCell.ConfigureData(amountString: nil, placeholder: "Сумма дохода")
        case .expense:
            return AmountFieldCell.ConfigureData(amountString: nil, placeholder: "Сумма расхода")
        case .null:
            return AmountFieldCell.ConfigureData(amountString: nil, placeholder: "")
        }
    }
    
    func categoryCellConfigureData(description: String?) -> SelectionCell.ConfigureData {
        return SelectionCell.ConfigureData(title: "Категория",
                                           description: description)
    }
    
    func datePickerCellConfigureData() -> NewOperationDatePickerCell.ConfigureData {
        guard let localeId = Locale.preferredLanguages.first else {
            return NewOperationDatePickerCell.ConfigureData(title: "Дата",
                                                            description: "",
                                                            date: Date(),
                                                            datePickerMode: UIDatePicker.Mode.date,
                                                            localeId: "",
                                                            dateFormatter: nil,
                                                            translateDataClosure: nil)
        }
        
        let dateFormatter = DateFormatter.dayMonthFormatter
        let dateString = dateFormatter.string(from: Date())
        
        let translateDataClosure: (CellDataDelegate?, Any) -> Void = { delegate, data in
            guard let strongDate = data as? Date else { return }
            delegate?.translateDate(strongDate)
        }
        
        return NewOperationDatePickerCell.ConfigureData(title: "Дата",
                                                        description: dateString,
                                                        date: Date(),
                                                        datePickerMode: UIDatePicker.Mode.date,
                                                        localeId: localeId,
                                                        dateFormatter: dateFormatter,
                                                        translateDataClosure: translateDataClosure)
    }
    
    func timePickerCellConfigureData() -> NewOperationDatePickerCell.ConfigureData {
        guard let localeId = Locale.preferredLanguages.first else {
            return NewOperationDatePickerCell.ConfigureData(title: "Время",
                                                            description: "",
                                                            date: Date(),
                                                            datePickerMode: UIDatePicker.Mode.time,
                                                            localeId: "",
                                                            dateFormatter: nil,
                                                            translateDataClosure: nil)
        }
        
        let timeFormatter = DateFormatter.timeFormatter
        let dateString = timeFormatter.string(from: Date())
        
        let translateDataClosure: (CellDataDelegate?, Any) -> Void = { delegate, data in
            guard let strongDate = data as? Date else { return }
            delegate?.translateDate(strongDate)
        }
        
        return NewOperationDatePickerCell.ConfigureData(title: "Время",
                                                        description: dateString,
                                                        date: Date(),
                                                        datePickerMode: UIDatePicker.Mode.time,
                                                        localeId: localeId,
                                                        dateFormatter: timeFormatter,
                                                        translateDataClosure: translateDataClosure)
    }
}
