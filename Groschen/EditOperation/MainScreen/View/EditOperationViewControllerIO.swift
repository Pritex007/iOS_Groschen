import Foundation

protocol EditOperationViewControllerInput: AnyObject {
    func configureCategory(_ configureData: SelectionCell.ConfigureData)
    func enableSaveButton()
    func disableSaveButton()
    func endEditting()
}

protocol EditOperationViewControllerOutput: AnyObject {
    func didTapDeleteButton()
    func didTapCategory()
    func configureDatePickerCell(type: NewOperationModel.CellType) -> NewOperationDatePickerCell.ConfigureData?
    func didTapSaveButton()
    func configureAmountCell() -> AmountFieldCell.ConfigureData
    func configureCommentCell() -> String
    func configureCategoryCell() -> SelectionCell.ConfigureData
}
