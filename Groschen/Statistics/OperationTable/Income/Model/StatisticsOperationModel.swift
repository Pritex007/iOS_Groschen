import Foundation

final class StatisticsOperationModel {
    
    // MARK: Internal properties
    
    weak var output: StatisticsOperationModelOutput?
    
    // MARK: Private properties
    
    private var data: [(cellInfo: [OperationEntity], totalAmount: Decimal)] = []
    
    private var intervalType: StatisticsIntervalSelectionCell.CellType = .month
    private var startDate: Date?
    private var endDate: Date?
    
    // MARK: Internal methods
    
    func setIntervalInfo(_ type: StatisticsIntervalSelectionCell.CellType, _ startDate: Date?, _ endDate: Date?) {
        intervalType = type
        self.startDate = startDate
        self.endDate = endDate
    }
}

// MARK: - IncomeModelInput

extension StatisticsOperationModel: StatisticsOperationModelInput {
    
    func loadDataInModel(data: [(cellInfo: [OperationEntity], totalAmount: Decimal)]) {
        self.data = data
        output?.dataChanged()
    }
    
    func getStartDate() -> Date? {
        return startDate
    }
    
    func getEndDate() -> Date? {
        return endDate
    }
    
    func getIntervalType() -> StatisticsIntervalSelectionCell.CellType {
        return intervalType
    }
    
    func getNumberOfCellsInSection(index: Int) -> Int {
        return data[index].cellInfo.count
    }
    
    func getNumberOfSections() -> Int {
        return data.count
    }
    
    func configureSectionHeader(index: Int) -> String {
        let title: String
        switch intervalType {
        case .custom:
            guard let startDate = startDate,
                  let endDate = endDate
            else {
                return ""
            }
            title = DateFormatter.dayMonthYearFormatter.string(from: startDate) + " - " + DateFormatter.dayMonthYearFormatter.string(from: endDate)
        case .month:
            title = DateFormatter.monthYearFormatter.string(from: data.isEmpty || data[index].cellInfo.isEmpty ? Date() : data[index].cellInfo[0].dateTime)
        case .year:
            title = DateFormatter.yearFormatter.string(from: data.isEmpty || data[index].cellInfo.isEmpty ? Date() : data[index].cellInfo[0].dateTime)
        }
        return title
    }
    
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity {
        return data[sectionIndex].cellInfo[cellIndex]
    }
}
