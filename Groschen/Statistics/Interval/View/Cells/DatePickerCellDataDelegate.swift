import Foundation

protocol DatePickerCellDataTransferDelegate: AnyObject {
    func startDateChanged(_ date: Date) -> Date
    func endDateChanged(_ date: Date) -> Date
}
