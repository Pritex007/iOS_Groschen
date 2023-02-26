import Foundation

final class StatisticsPresenter {
    
    // MARK: Internal properties
    
    weak var view: StatisticsViewInput?
    weak var output: StatisticsModuleOutput?
    var model: StatisticsModelInput?
    
    // MARK: Private properties
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    
    private let configureDataFactory: StatisticsConfigureDataFactoryProtocol
    
    // MARK: Lifecycle
    
    init(coreDataManager: CoreDataManagerProtocol,
         storageRequestFactory: FetchRequestFactoryProtocol,
         storage: StorageProtocol,
         configureDataFactory: StatisticsConfigureDataFactoryProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = storageRequestFactory
        self.storage = storage
        self.configureDataFactory = configureDataFactory
    }
}

// MARK: - StatisticsViewOutput

extension StatisticsPresenter: StatisticsViewOutput {
    func intervalTapped() {
        guard let type = model?.getIntervalType() else { return }
        guard let startDate = model?.getStartDate(),
              let endDate = model?.getEndDate(),
              type == .custom
        else {
            output?.openIntervalSelectionScreen(type, nil, nil)
            return
        }
        output?.openIntervalSelectionScreen(type, startDate, endDate)
    }
    
    func didTapCell(type: StatisticsModel.CellType) {
        switch type {
        case .income:
            guard let type = model?.getIntervalType(),
                  let startDate = model?.getStartDate(),
                  let endDate = model?.getEndDate()
            else { return }
            output?.openIncomeScreen(type, startDate, endDate)
        case .expense:
            guard let type = model?.getIntervalType(),
                  let startDate = model?.getStartDate(),
                  let endDate = model?.getEndDate()
            else { return }
            output?.openExpenseScreen(type, startDate, endDate)
        case .balance:
            break
        }
    }
    
    func configureIncomeCell() ->SelectionCell.ConfigureData {
        guard let count = model?.getIncomeCount()
        else {
            return SelectionCell.ConfigureData(
                title: "",
                description: ""
            )
        }
        return configureDataFactory.configureIncomeSelectionCell(count: count)
    }
    
    func configureExpenseCell() -> SelectionCell.ConfigureData {
        guard let count = model?.getExpenseCount()
        else {
            return SelectionCell.ConfigureData(
                title: "",
                description: ""
            )
        }
        return configureDataFactory.configureExpenseSelectionCell(count: count)
    }
    
    func configureBalanceCell() -> StatisticsBalanceSelectionCell.ConfigureData {
        guard let summary = model?.getBalance() else {
            return StatisticsBalanceSelectionCell.ConfigureData(
                title: "",
                amount: "",
                currencyImage: nil
            )
        }
        return configureDataFactory.configureBalanceSelectionCell(amount: summary, currencyIndex: 643)
    }
    
    func viewNeedsData() {
        let group = DispatchGroup()
        var expenseSummary: Decimal = 0
        var incomSummary: Decimal = 0
        group.enter()
        storage.obtainIncome() { result in
            switch result {
            case .failure(_):
                group.leave()
            case .success(let data):
                self.model?.obtainIncomeCount(count: data.count)
                data.forEach { operation in
                    incomSummary += operation.amount
                }
                group.leave()
            }
        }
        group.enter()
        storage.obtainExpense() { result in
            switch result {
            case .failure(_):
                group.leave()
            case .success(let data):
                self.model?.obtainExpenseCount(count: data.count)
                data.forEach { operation in
                    expenseSummary += operation.amount
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.model?.addToBalance(amount: expenseSummary + incomSummary)
        }
    }
}

// MARK: - StatisticsModelOutput

extension StatisticsPresenter: StatisticsModelOutput {
    func dataChanged() {
        view?.reloadTable()
    }
}

// MARK: - StatisticsOperationModelOutput

extension StatisticsPresenter: StatisticsModuleInput {
    func obtainInterval(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        model?.obtainIntervalType(type: type)
        guard let startDate = startDate,
              let endDate = endDate
        else { return }
        model?.obtainStartDate(date: startDate)
        model?.obtainEndDate(date: endDate)
    }
}
