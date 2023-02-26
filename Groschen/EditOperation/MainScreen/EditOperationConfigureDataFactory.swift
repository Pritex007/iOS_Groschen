import Foundation
import UIKit


protocol EditOperationConfigureDataFactoryProtocol {
    func categoryCellConfigureData(description: String?) -> SelectionCell.ConfigureData
    func datePickerCellConfigureData(date: Date) -> NewOperationDatePickerCell.ConfigureData
    func timePickerCellConfigureData(time: Date) -> NewOperationDatePickerCell.ConfigureData
    func amountCellConfigureString(operationType: OperationType, amount: Decimal) -> AmountFieldCell.ConfigureData
}

final class EditOperationConfigureDataFactory: EditOperationConfigureDataFactoryProtocol {
    
    // MARK: - Private constants
    
    private enum Constants {
        enum DatePicker {
            static let height: CGFloat = 300
        }
        enum ToolBar {
            static let height: CGFloat = 50
        }
    }
    
    // MARK: - Internal methods
    
    func amountCellConfigureString(operationType: OperationType, amount: Decimal) -> AmountFieldCell.ConfigureData {
        var operationAmount: Decimal = 0
        var placeholder: String
        switch operationType {
        case .income:
            placeholder = "Сумма дохода"
            operationAmount = amount
        case .expense:
            placeholder = "Сумма расхода"
            operationAmount = -1 * amount
        case .null:
            placeholder = ""
        }
        
        guard let amountString = NumberFormatter.splittedMoneyFormatter.string(from: NSDecimalNumber(decimal: operationAmount))
        else {
            return AmountFieldCell.ConfigureData(amountString: nil, placeholder: "")
        }
        
        let preparedAmount = amountString.trimmingCharacters(in: .whitespaces)
        return AmountFieldCell.ConfigureData(amountString: preparedAmount, placeholder: placeholder)
    }
    
    func categoryCellConfigureData(description: String?) -> SelectionCell.ConfigureData {
        return SelectionCell.ConfigureData(title: "Категория",
                                           description: description)
    }
    
    func datePickerCellConfigureData(date: Date) -> NewOperationDatePickerCell.ConfigureData {
        guard let localeId = Locale.preferredLanguages.first else {
            return NewOperationDatePickerCell.ConfigureData(title: "Дата",
                                                            description: "",
                                                            date: date,
                                                            datePickerMode: UIDatePicker.Mode.date,
                                                            localeId: "",
                                                            dateFormatter: nil,
                                                            translateDataClosure: nil)
        }
        
        let dateFormatter = DateFormatter.dayMonthFormatter
        let dateString = dateFormatter.string(from: date)
        
        let translateDataClosure: (CellDataDelegate?, Any) -> Void = { delegate, data in
            guard let strongDate = data as? Date else { return }
            delegate?.translateDate(strongDate)
        }
        
        return NewOperationDatePickerCell.ConfigureData(title: "Дата",
                                                        description: dateString,
                                                        date: date,
                                                        datePickerMode: UIDatePicker.Mode.date,
                                                        localeId: localeId,
                                                        dateFormatter: dateFormatter,
                                                        translateDataClosure: translateDataClosure)
    }
    
    func timePickerCellConfigureData(time: Date) -> NewOperationDatePickerCell.ConfigureData {
        guard let localeId = Locale.preferredLanguages.first else {
            return NewOperationDatePickerCell.ConfigureData(title: "Время",
                                                            description: "",
                                                            date: time,
                                                            datePickerMode: UIDatePicker.Mode.time,
                                                            localeId: "",
                                                            dateFormatter: nil,
                                                            translateDataClosure: nil)
        }
        
        let timeFormatter = DateFormatter.timeFormatter
        let dateString = timeFormatter.string(from: time)
        
        let translateDataClosure: (CellDataDelegate?, Any) -> Void = { delegate, data in
            guard let strongDate = data as? Date else { return }
            delegate?.translateDate(strongDate)
        }
        
        return NewOperationDatePickerCell.ConfigureData(title: "Время",
                                                        description: dateString,
                                                        date: time,
                                                        datePickerMode: UIDatePicker.Mode.time,
                                                        localeId: localeId,
                                                        dateFormatter: timeFormatter,
                                                        translateDataClosure: translateDataClosure)
    }
}
