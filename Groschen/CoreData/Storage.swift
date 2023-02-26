import Foundation

enum StorageError: Error {
    case noData
}

protocol StorageProtocol {
    func saveOperation(operation: OperationEntity, completion: @escaping (Result<OperationEntity, Error>) -> Void)
    func saveCategory(category: CategoryEntity, completion: @escaping (Result<CategoryEntity, Error>) -> Void)
    func obtainIncome(completion: @escaping (Result<[OperationEntity], Error>) -> Void)
    func obtainExpense(completion: @escaping (Result<[OperationEntity], Error>) -> Void)
    func obtainCategory(operationType: OperationType, completion: @escaping (Result<[CategoryEntity], Error>) -> Void)
    func obtainCategoryModel(categoryId: String, completion: @escaping (Result<CategoryModel, Error>) -> Void)
    func obtainOperationModel(operationId: String, completion: @escaping (Result<OperationModel, Error>) -> Void)
    func editOperation(operation: OperationEntity, completion: @escaping (Result<OperationEntity, Error>) -> Void)
    func removeOperation(operationId: String)
    func removeAllOperations()
    func removeAllCategories()
}

final class Storage: StorageProtocol {
    
    // MARK: Private properties
    
    private let coreDataManager: CoreDataManagerProtocol!
    private let storageRequestFactory: FetchRequestFactoryProtocol!
    
    // MARK: Lifecycle
    
    init(coreDataManager: CoreDataManagerProtocol, storageRequestFactory: FetchRequestFactoryProtocol) {
        self.coreDataManager = coreDataManager
        self.storageRequestFactory = storageRequestFactory
    }
    
    // MARK: Internal methods
    
    func saveOperation(operation: OperationEntity, completion: @escaping (Result<OperationEntity, Error>) -> Void) {
        let context = coreDataManager.writeContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let operationModel = OperationModel.convert(dto: operation, into: context)
            let categoryRequest = strongSelf.storageRequestFactory.categoryRequest(categoryId: operation.category.categoryId)
            do {
                let categoryFetchRequestResult = try context.fetch(categoryRequest)
                
                guard let categoryModel = categoryFetchRequestResult.first,
                      let set = categoryModel.operation?.adding(operationModel) else {
                    return
                }
                
                operationModel.category = categoryModel
                categoryModel.operation = set as NSSet
                
                try context.save()
                completion(.success(operation))
            } catch {
                assertionFailure("Error when saving context \(error)")
                context.rollback()
                completion(.failure(error))
            }
        }
    }
    
    func editOperation(operation: OperationEntity, completion: @escaping (Result<OperationEntity, Error>) -> Void) {
        let context = coreDataManager.writeContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let operationRequest = strongSelf.storageRequestFactory.operationRequest(operationId: operation.operationId)
            let categoryRequest = strongSelf.storageRequestFactory.categoryRequest(categoryId: operation.category.categoryId)
            do {
                let operationFetchRequestResult = try context.fetch(operationRequest)
                let categoryFetchRequestResult = try context.fetch(categoryRequest)
                
                guard let operationModel = operationFetchRequestResult.first,
                      let categoryModel = categoryFetchRequestResult.first,
                      let set = categoryModel.operation?.adding(operationModel) else {
                    return
                }
                
                operationModel.category = categoryModel
                categoryModel.operation = set as NSSet
                
                operationModel.copy(operation)
                
                try context.save()
                completion(.success(operation))
            } catch {
                assertionFailure("Error when saving context \(error)")
                context.rollback()
                completion(.failure(error))
            }
        }
    }
    
    func saveCategory(category: CategoryEntity, completion: @escaping (Result<CategoryEntity, Error>) -> Void) {
        let context = coreDataManager.writeContext
        context.perform {
            CategoryModel.convert(dto: category, into: context)
            do {
                try context.save()
                completion(.success(category))
            } catch {
                assertionFailure("Error when saving context \(error)")
                context.rollback()
                completion(.failure(error))
            }
        }
    }
    
    func obtainIncome(completion: @escaping (Result<[OperationEntity], Error>) -> Void) {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.incomeRequest()
            do {
                let fetchRequestResults = try context.fetch(request)
                let dtoModel = fetchRequestResults.map { (element) -> OperationEntity in
                    return element.convertToDTO()
                }
                completion(.success(dtoModel))
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func obtainOperationModel(operationId: String, completion: @escaping (Result<OperationModel, Error>) -> Void) {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.operationRequest(operationId: operationId)
            do {
                let fetchRequestResults = try context.fetch(request)
                guard let operationModel = fetchRequestResults.first else {
                    return
                }
                completion(.success(operationModel))
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func obtainExpense(completion: @escaping (Result<[OperationEntity], Error>) -> Void) {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.expenseRequest()
            do {
                let fetchRequestResults = try context.fetch(request)
                let dtoModel = fetchRequestResults.map { (element) -> OperationEntity in
                    return element.convertToDTO()
                }
                completion(.success(dtoModel))
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func obtainCategory(operationType: OperationType, completion: @escaping (Result<[CategoryEntity], Error>) -> Void) {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.categoryRequest(operationType: operationType)
            do {
                let fetchRequestResults = try context.fetch(request)
                let dtoModel = fetchRequestResults.map { (element) -> CategoryEntity in
                    return element.convertToDTO()
                }
                completion(.success(dtoModel))
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func obtainCategoryModel(categoryId: String, completion: @escaping (Result<CategoryModel, Error>) -> Void) {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.categoryRequest(categoryId: categoryId)
            do {
                let fetchRequestResults = try context.fetch(request)
                guard let categoryModel = fetchRequestResults.first else {
                    return
                }
                completion(.success(categoryModel))
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func removeOperation(operationId: String) {
        let context = coreDataManager.writeContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.operationRequest(operationId: operationId)
            do {
                let fetchRequestResults = try context.fetch(request)
                guard let operation = fetchRequestResults.first else {
                    return
                }
                context.delete(operation)
                try context.save()
            } catch {
                assertionFailure("Error when obtaining Income \(error)")
            }
        }
    }
    
    func removeAllOperations() {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.removeAllOperationsRequest()
            do {
                try context.execute(request)
                try context.save()
            } catch {
                assertionFailure("Error when deleting AllOperations \(error)")
            }
        }
    }
    
    func removeAllCategories() {
        let context = coreDataManager.readContext
        context.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request = strongSelf.storageRequestFactory.removeAllCategoriesRequest()
            do {
                try context.execute(request)
                try context.save()
            } catch {
                assertionFailure("Error when deleting AllOperations \(error)")
            }
        }
    }
}
