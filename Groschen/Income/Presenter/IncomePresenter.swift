import Foundation

final class IncomePresenter {
    weak var view: IncomeViewInput?
    var model: IncomeModelInput?
    weak var output: IncomeModuleOutput?
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    private let displayDataFactory: OperationDisplayDataFactoryProtocol
    
    private var isFirst = true
    
    init(coreDataManager: CoreDataManagerProtocol, storageRequestFactory: FetchRequestFactoryProtocol, displayDataFactory: OperationDisplayDataFactoryProtocol, storage: StorageProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = FetchRequestFactory()
        self.storage = storage
        self.displayDataFactory = OperationDisplayDataFactory()
    }
}

// MARK: - IncomeViewOutput

extension IncomePresenter: IncomeViewOutput {
    func didTapCell(indexPath: IndexPath) {
        guard let operation = model?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section)
        else {
            return
        }
        output?.incomeModuleWantsToOpenEditOperationScreen(operation: operation)
    }
    
    func getNumberOfSections() -> Int {
        guard let result = model?.getNumberOfSections() else { return 0 }
        return result
    }
    
    func getNumberOfCellsInSection(index: Int) -> Int {
        guard let result = model?.getNumberOfCellsInSection(index: index) else { return 0 }
        return result
    }
    
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationCell.DisplayData {
        guard let result = model?.configureCell(cellIndex: cellIndex, sectionIndex: sectionIndex) else {
            return displayDataFactory.operationDisplayData(categoryName: "",
                                                           commentText: nil,
                                                           date: Date(),
                                                           amount: 0,
                                                           currency: 0)
        }
        let displayData = displayDataFactory.operationDisplayData(categoryName: result.category.title,
                                                                  commentText: result.comment,
                                                                  date: result.dateTime,
                                                                  amount: result.amount,
                                                                  currency: Int(result.currency))
        return displayData
    }
    
    func configureSectionHeader(index: Int) -> (date: String, amount: AmountView.DisplayData) {
        guard let configureData = model?.configureSectionHeader(index: index) else { return ("", AmountView.DisplayData(amount: "0", currencyImage: nil)) }
        let amount = displayDataFactory.amountViewDisplayData(amount: configureData.totalAmount, currency: 643)
        return (date: configureData.date, amount: amount)
    }
    
    func viewWillAppear() {
        storage.obtainIncome() {[weak self] result in
            switch result {
            case .failure(_):
                break
            case .success(let data):
                if !data.isEmpty {
                    var resultData: [(cellInfo: [OperationEntity], totalAmount: Decimal)] = []
                    
                    resultData.append(([data[0]], data[0].amount))
                    let formatter = DateFormatter.dayMonthFormatter
                    
                    for i in 1..<data.count {
                        if formatter.string(from: data[i].dateTime) == formatter.string(from: data[i-1].dateTime) {
                            resultData[resultData.count - 1].cellInfo.append(data[i])
                            resultData[resultData.count - 1].totalAmount += data[i].amount
                        } else {
                            resultData.append(([data[i]], data[i].amount))
                        }
                    }
                    self?.model?.loadDataInModel(data: resultData)
                }
            }
        }
    }
    
    func addNewIncome() {
        output?.incomeModuleWantsToOpenNewIncomeScreen()
    }
    
    func userDidSelectIncomeCell(at indexPath: IndexPath) {
        guard let operation = model?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section) else {
            return
        }
        output?.incomeModuleWantsToOpenEditOperationScreen(operation: operation)
    }
}

// MARK: - IncomeModelOutput

extension IncomePresenter: IncomeModelOutput {
    func reloadDataInView() {
        DispatchQueue.main.async {
            self.view?.reloadTable()
        }
    }
}
