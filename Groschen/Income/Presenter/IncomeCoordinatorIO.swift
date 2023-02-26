protocol IncomeModuleOutput: AnyObject {
    func incomeModuleWantsToOpenNewIncomeScreen()
    func incomeModuleWantsToOpenEditOperationScreen(operation: OperationEntity)
}
