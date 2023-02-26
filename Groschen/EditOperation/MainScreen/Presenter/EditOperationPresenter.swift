import Foundation

final class EditOperationPresenter {
    
    // MARK: - Internal properties
    
    weak var view: EditOperationViewControllerInput?
    var model: EditOperationModelInput?
    weak var output: EditOperationModuleOutput?
    
    var operationType: OperationType = .null
    
    // MARK: - Private properties
    
    private let coreDataManager: CoreDataManagerProtocol
    private let storageRequestFactory: FetchRequestFactoryProtocol
    private let storage: StorageProtocol
    
    private let configureDataFactory: EditOperationConfigureDataFactoryProtocol
    
    // MARK: - Lifecycle
    
    init(coreDataManager: CoreDataManagerProtocol, storageRequestFactory: FetchRequestFactoryProtocol, storage: StorageProtocol, configureDataFactory: EditOperationConfigureDataFactoryProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = storageRequestFactory
        self.storage = storage
        self.configureDataFactory = configureDataFactory
    }
}

// MARK: - EditOperationViewControllerOutput

extension EditOperationPresenter: EditOperationModelOutput {
    func enoughDataToSave() {
        view?.enableSaveButton()
    }
    
    func notEnoughDataToSave() {
        view?.disableSaveButton()
    }
    
    func categoryChanged(category: String) {
        let info = configureDataFactory.categoryCellConfigureData(description: category)
        view?.configureCategory(info)
    }
}

// MARK: - EditOperationViewControllerOutput

extension EditOperationPresenter: EditOperationViewControllerOutput {
    func configureCategoryCell() -> SelectionCell.ConfigureData {
        guard let category = model?.getCategory()
        else {
            return  SelectionCell.ConfigureData(title: "", description: nil)
        }
        let info = configureDataFactory.categoryCellConfigureData(description: category)
        return info
    }
    
    func configureAmountCell() -> AmountFieldCell.ConfigureData {
        guard let amount = model?.getAmount()
        else {
            return AmountFieldCell.ConfigureData(amountString: "", placeholder: "")
        }
        
        let info = configureDataFactory.amountCellConfigureString(operationType: operationType, amount: amount)
        return info
    }
    
    func configureCommentCell() -> String {
        guard let comment = model?.getComment() else { return "" }
        return comment
    }
    
    func configureDatePickerCell(type: NewOperationModel.CellType) -> NewOperationDatePickerCell.ConfigureData? {
        guard let date = model?.getDate() else { return nil }
        switch type {
        case .date:
            let info = configureDataFactory.datePickerCellConfigureData(date: date)
            return info
        case .dateTime:
            let info = configureDataFactory.timePickerCellConfigureData(time: date)
            return info
        case .amount, .category, .comment:
            return nil
        }
    }
    
    func didTapCategory() {
        let result = model?.getCategory()
        output?.editOperationModuleWantsToOpenCategoryScreen(selectedCategory: result, operationType: operationType)
    }
    
    func didTapSaveButton() {
        guard let operation = model?.getOperation()
        else {
            return
        }
        self.storage.editOperation(operation: operation) { result in
            switch result {
            case .failure(_):
                break
            case .success(_):
                DispatchQueue.main.async {
                    self.output?.editOperationModuleWantsToFinish()
                }
            }
        }
    }
    
    func didTapDeleteButton() {
        guard let operationId = model?.getOperation().operationId else { return }
        storage.removeOperation(operationId: operationId)
        output?.editOperationModuleWantsToFinish()
    }
}

// MARK: - EditOperationModuleInput

extension EditOperationPresenter: EditOperationModuleInput {
    func setSelectedCategory(categoryId: String, categoryTitle: String) {
        model?.setCategory(CategoryEntity(categoryId: categoryId,
                                          title: categoryTitle,
                                          operationType: operationType))
    }
}

// MARK: - CellDataDelegate

extension EditOperationPresenter: CellDataDelegate {
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
