import Foundation

final class StatisticsModel {
    
    // MARK: Internal enum
    
    enum CellType: Int {
        case income = 0
        case expense = 1
        case balance = 2
    }
    
    // MARK: Internal properties
    
    weak var output: StatisticsModelOutput?
    
    // MARK: Private properties
    
    private var incomeCount: Int = 0
    private var expenseCount: Int = 0
    private var balance: Decimal = 0
    
    private var intervalType: StatisticsIntervalSelectionCell.CellType = .month
    private var startDate: Date = Date()
    private var endDate: Date = Date()
}

// MARK: - StatisticsModelInput

extension StatisticsModel: StatisticsModelInput {
    func obtainIncomeCount(count: Int) {
        incomeCount = count
    }
    
    func obtainExpenseCount(count: Int) {
        expenseCount = count
    }
    
    func obtainIntervalType(type: StatisticsIntervalSelectionCell.CellType) {
        intervalType = type
    }
    
    func obtainStartDate(date: Date) {
        startDate = date
    }
    
    func obtainEndDate(date: Date) {
        endDate = date
    }
    
    func addToBalance(amount: Decimal) {
        balance += amount
        output?.dataChanged()
    }
    
    func getIncomeCount() -> Int {
        return incomeCount
    }
    
    func getExpenseCount() -> Int {
        return expenseCount
    }
    
    func getBalance() -> Decimal {
        return balance
    }
    
    func getIntervalType() -> StatisticsIntervalSelectionCell.CellType {
        return intervalType
    }
    
    func getStartDate() -> Date {
        return startDate
    }
    
    func getEndDate() -> Date {
        return endDate
    }
}
