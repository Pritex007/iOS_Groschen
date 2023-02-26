import Foundation

final class StatisticsOperationPresenter {
    
    // MARK: Internal properties
    
    weak var view: StatisticsOperationViewInput?
    var model: StatisticsOperationModelInput?
    
    // MARK: Private properties
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    private let displayDataFactory: OperationDisplayDataFactoryProtocol
    
    // MARK: Lifecycle
    
    init(coreDataManager: CoreDataManagerProtocol, storageRequestFactory: FetchRequestFactoryProtocol, displayDataFactory: OperationDisplayDataFactoryProtocol, storage: StorageProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = FetchRequestFactory()
        self.storage = storage
        self.displayDataFactory = OperationDisplayDataFactory()
    }
}

// MARK: - StatisticsOperationOutput

extension StatisticsOperationPresenter: StatisticsOperationViewOutput {
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
    
    func configureSectionHeader(index: Int) -> StatisticsOperationSectionHeader.DisplayData {
        guard let title = model?.configureSectionHeader(index: index) else { return StatisticsOperationSectionHeader.DisplayData(title: "") }
        return StatisticsOperationSectionHeader.DisplayData(title: title)
    }
    
    func viewWillAppear() {
        let monthFormatter = DateFormatter.monthYearFormatter
        let yearFormatter = DateFormatter.yearFormatter
        
        guard let intervalType = model?.getIntervalType() else { return }
        storage.obtainIncome() { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(_):
                break
            case .success(let data):
                if !data.isEmpty {
                    var resultData: [(cellInfo: [OperationEntity], totalAmount: Decimal)]
                    
                    switch intervalType {
                    case .month:
                        resultData = strongSelf.operationsByFormatter(data: data, formatter: monthFormatter)
                    case .custom:
                        resultData = strongSelf.operationByCustomInterval(data: data)
                    case .year:
                        resultData = strongSelf.operationsByFormatter(data: data, formatter: yearFormatter)
                    }
                    self?.model?.loadDataInModel(data: resultData)
                }
            }
        }
    }
    
    private func operationsByFormatter(data: [OperationEntity], formatter: DateFormatter) -> [(cellInfo: [OperationEntity], totalAmount: Decimal)] {
        var resultData: [(cellInfo: [OperationEntity], totalAmount: Decimal)] = []
        
        resultData.append(([data[0]], data[0].amount))
        
        for i in 1..<data.count {
            if formatter.string(from: data[i].dateTime) == formatter.string(from: data[i-1].dateTime) {
                resultData[resultData.count - 1].cellInfo.append(data[i])
                resultData[resultData.count - 1].totalAmount += data[i].amount
            } else {
                resultData.append(([data[i]], data[i].amount))
            }
        }
        
        return resultData
    }
    
    private func operationByCustomInterval(data: [OperationEntity]) -> [(cellInfo: [OperationEntity], totalAmount: Decimal)] {
        guard let startDate = model?.getStartDate(),
              let endDate = model?.getEndDate()
        else {
            return []
        }
        
        var resultData: [(cellInfo: [OperationEntity], totalAmount: Decimal)] = []
        
        resultData.append(([], 0))
        
        for i in 0..<data.count {
            if endDate > data[i].dateTime && data[i].dateTime > startDate {
                resultData[0].cellInfo.append(data[i])
                resultData[0].totalAmount += data[i].amount
            }
        }
        
        return resultData
    }
}

// MARK: - StatisticsOperationModelOutput

extension StatisticsOperationPresenter: StatisticsOperationModelOutput {
    func dataChanged() {
        DispatchQueue.main.async {
            self.view?.reloadTable()
        }
    }
}
