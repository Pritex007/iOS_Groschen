protocol ExpenseModuleOutput: AnyObject {
    func expenseModuleWantsToOpenNewExpenseScreen()
    func expenseModuleWantsToOpenEditOperationScreen(operation: OperationEntity)
}
