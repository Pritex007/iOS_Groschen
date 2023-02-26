import Foundation

final class NewOperationPresenter {
    weak var view: NewOperationViewControllerInput?
    var model: NewOperationModelInput?
    weak var output: NewOperationModuleOutput?
    
    var operationType: OperationType = .null
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    
    private let configureDataFactory: NewOperationConfigureDataFactoryProtocol
    
    init(coreDataManager: CoreDataManagerProtocol, storageRequestFactory: FetchRequestFactoryProtocol, storage: StorageProtocol, configureDataFactory: NewOperationConfigureDataFactoryProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = storageRequestFactory
        self.storage = storage
        self.configureDataFactory = configureDataFactory
    }
}

// MARK: - NewOperationModelOutput

extension NewOperationPresenter: NewOperationModelOutput {
    func enoughDataToSave() {
        view?.enableSaveButton()
    }
    
    func notEnoughDataToSave() {
        view?.disableSaveButton()
    }
    
    func categoryChanged(category: String) {
        let configureData = configureDataFactory.categoryCellConfigureData(description: category)
        view?.configureCategory(configureData: configureData)
    }
}

// MARK: - NewOperationViewControllerOutput

extension NewOperationPresenter: NewOperationViewControllerOutput {
    func configureCategoryCell() -> SelectionCell.ConfigureData {
        let info = configureDataFactory.categoryCellConfigureData(description: nil)
        return info
    }
    
    func configureAmountCell() -> AmountFieldCell.ConfigureData {
        let info = configureDataFactory.amountCellConfigureString(operationType: operationType)
        return info
    }
    
    func configureDatePickerCell(type: NewOperationModel.CellType) -> NewOperationDatePickerCell.ConfigureData? {
        switch type {
        case .date:
            let info = configureDataFactory.datePickerCellConfigureData()
            return info
        case .dateTime:
            let info = configureDataFactory.timePickerCellConfigureData()
            return info
        case .amount, .category, .comment:
            return nil
        }
    }
    
    func didTapCategoryCell() {
        let result = model?.getCategory()
        output?.openCategoryScreen(selectedCategory: result)
    }
    
    func didTapSaveButton() {
        guard let operation = model?.getOperation() else { return }
        storage.saveOperation(operation: operation) { [weak self] result in
            switch result {
            case .failure(_):
                break
            case .success(_):
                DispatchQueue.main.async {
                    self?.output?.finish()
                }
            }
        }
    }
}

// MARK: - NewOperationModuleInput

extension NewOperationPresenter: NewOperationModuleInput {
    func obtainSelectedCategory(categoryId: String, categoryTitle: String) {
        model?.setCategory(CategoryEntity(categoryId: categoryId,
                                          title: categoryTitle,
                                          operationType: operationType))
    }
}

// MARK: - CellDataDelegate

extension NewOperationPresenter: CellDataDelegate {
    func translateAmount(_ amount: Decimal) {
        switch operationType {
        case .income:
            model?.setAmount(amount)
        case .expense:
            model?.setAmount(-1 * amount)
        case .null:
            break
        }
    }
    
    func translateDate(_ date: Date) {
        model?.setDate(date)
    }
    
    func translateTime(_ time: Date) {
        model?.setTime(time)
    }
    
    func translateComment(_ comment: String) {
        model?.setComment(comment)
    }
}
