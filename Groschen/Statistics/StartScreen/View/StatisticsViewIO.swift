protocol StatisticsViewInput: AnyObject {
    func reloadTable()
}

protocol StatisticsViewOutput: AnyObject {
    func viewNeedsData()
    func configureIncomeCell() -> SelectionCell.ConfigureData
    func configureExpenseCell() -> SelectionCell.ConfigureData
    func configureBalanceCell() -> StatisticsBalanceSelectionCell.ConfigureData
    func didTapCell(type: StatisticsModel.CellType)
    func intervalTapped()
}
