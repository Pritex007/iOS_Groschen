import Foundation

protocol NewOperationViewControllerInput: AnyObject {
    func configureCategory(configureData: SelectionCell.ConfigureData)
    func enableSaveButton()
    func disableSaveButton()
    func endEditting()
}

protocol NewOperationViewControllerOutput: AnyObject {
    func configureDatePickerCell(type: NewOperationModel.CellType) -> NewOperationDatePickerCell.ConfigureData?
    func configureAmountCell() -> AmountFieldCell.ConfigureData
    func configureCategoryCell() -> SelectionCell.ConfigureData
    func didTapSaveButton()
    func didTapCategoryCell()
}
