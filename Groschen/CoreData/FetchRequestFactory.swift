import Foundation
import CoreData

protocol FetchRequestFactoryProtocol {
    func removeAllOperationsRequest() -> NSBatchDeleteRequest
    func removeAllCategoriesRequest() -> NSBatchDeleteRequest
    func expenseRequest() -> NSFetchRequest<OperationModel>
    func incomeRequest() -> NSFetchRequest<OperationModel>
    func categoryRequest(operationType: OperationType) -> NSFetchRequest<CategoryModel>
    func categoryRequest(categoryId: String) -> NSFetchRequest<CategoryModel>
    func operationRequest(operationId: String) -> NSFetchRequest<OperationModel>
}

final class FetchRequestFactory: FetchRequestFactoryProtocol {
    
    func incomeRequest() -> NSFetchRequest<OperationModel> {
        let request = NSFetchRequest<OperationModel>(entityName: OperationModel.entity().name ?? "")
        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(OperationModel.dateTime), ascending: false)
        
        let amountPredicate = NSPredicate(format: "%K > 0", #keyPath(OperationModel.amount))
        
        request.predicate = amountPredicate
        
        request.sortDescriptors = [dateSortDescriptor]
        
        return request
    }
    
    func expenseRequest() -> NSFetchRequest<OperationModel> {
        let request = NSFetchRequest<OperationModel>(entityName: OperationModel.entity().name ?? "")
        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(OperationModel.dateTime), ascending: false)
        let amountPredicate = NSPredicate(format: "%K < 0", #keyPath(OperationModel.amount))
        
        request.predicate = amountPredicate
        
        request.sortDescriptors = [dateSortDescriptor]
        
        return request
    }
    
    func removeAllOperationsRequest() -> NSBatchDeleteRequest {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: OperationModel.entity().name ?? "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        return deleteRequest
    }
    
    func removeAllCategoriesRequest() -> NSBatchDeleteRequest {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CategoryModel.entity().name ?? "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        return deleteRequest
    }
    
    func categoryRequest(operationType: OperationType) -> NSFetchRequest<CategoryModel> {
        let request = NSFetchRequest<CategoryModel>(entityName: CategoryModel.entity().name ?? "")
        
        let operationTypePredicate = NSPredicate(format: "%K == %d", #keyPath(CategoryModel.operationType), operationType.rawValue)
        
        request.predicate = operationTypePredicate
        
        return request
    }
    
    func operationRequest(operationId: String) -> NSFetchRequest<OperationModel> {
        let request = NSFetchRequest<OperationModel>(entityName: OperationModel.entity().name ?? "")
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(OperationModel.operationId), operationId)
    
        request.predicate = idPredicate
        
        return request
    }
    
    func categoryRequest(categoryId: String) -> NSFetchRequest<CategoryModel> {
        let request = NSFetchRequest<CategoryModel>(entityName: CategoryModel.entity().name ?? "")
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(CategoryModel.categoryId), categoryId)
        
        request.predicate = idPredicate
        
        return request
    }
}
