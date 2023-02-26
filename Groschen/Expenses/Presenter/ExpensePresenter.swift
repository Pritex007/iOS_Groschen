import Foundation

final class ExpensePresenter {
    weak var view: ExpenseViewInput?
    var model: ExpenseModelInput?
    weak var output: ExpenseModuleOutput?
    
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

// MARK: - ExpenseViewOutput

extension ExpensePresenter: ExpenseViewOutput {
    func didTapCell(indexPath: IndexPath) {
        guard let operation = model?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section)
        else {
            return
        }
        output?.expenseModuleWantsToOpenEditOperationScreen(operation: operation)
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
    
    func configureSectionHeader(index: Int) -> OperationSectionHeader.DisplayData {
        guard let sectionData = model?.configureSectionHeader(index: index)
        else {
            return OperationSectionHeader.DisplayData(date: "",
                                                      amount: AmountView.DisplayData(amount: "", currencyImage: nil))
        }
        return displayDataFactory.sectionHeaderDisplayData(sectionData: sectionData)
    }
    
    func viewWillAppear() {
        storage.obtainExpense() {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                break
            case .success(let data):
                if !data.isEmpty {
                    let resultData = strongSelf.splitOperationIntoSections(data)
                    strongSelf.model?.loadData(data: resultData)
                }
            }
        }
    }
    
    func splitOperationIntoSections(_ operationArray: [OperationEntity]) -> [OperationSectionData] {
        var resultArray: [OperationSectionData] = []
        
        resultArray.append(OperationSectionData(cellInfo: [operationArray[0]], totalAmount: operationArray[0].amount))
        
        let formatter = DateFormatter.dayMonthFormatter
        
        for i in 1..<operationArray.count {
            if formatter.string(from: operationArray[i].dateTime) == formatter.string(from: operationArray[i-1].dateTime) {
                resultArray[resultArray.count - 1].cellInfo.append(operationArray[i])
                resultArray[resultArray.count - 1].totalAmount += operationArray[i].amount
            } else {
                resultArray.append(OperationSectionData(cellInfo: [operationArray[i]], totalAmount: operationArray[i].amount))
            }
        }
        
        return resultArray
    }
    
    func addNewExpense() {
        output?.expenseModuleWantsToOpenNewExpenseScreen()
    }
    
    func userDidSelectExpenseCell(at indexPath: IndexPath) {
        guard let operation = model?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section) else {
            return
        }
        output?.expenseModuleWantsToOpenEditOperationScreen(operation: operation)
    }
}

// MARK: - ExpenseModelOutput

extension ExpensePresenter: ExpenseModelOutput {
    func dataChanged() {
        DispatchQueue.main.async {
            self.view?.reloadTable()
        }
    }
}
