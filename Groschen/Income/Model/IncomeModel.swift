import Foundation

final class IncomeModel {
    weak var output: IncomeModelOutput?
    
    private var data: [(cellInfo: [OperationEntity], totalAmount: Decimal)] = []
}

// MARK: - IncomeModelInput

extension IncomeModel: IncomeModelInput {
    
    func loadDataInModel(data: [(cellInfo: [OperationEntity], totalAmount: Decimal)]) {
        self.data = data
        output?.reloadDataInView()
    }
    
    func getNumberOfCellsInSection(index: Int) -> Int {
        return data[index].cellInfo.count
    }
    
    func getNumberOfSections() -> Int {
        return data.count
    }
    
    func configureSectionHeader(index: Int) -> (date: String, totalAmount: Decimal) {
        let date = DateFormatter.sectionDateFormatter.string(from: data[index].cellInfo[0].dateTime)
        return (date, data[index].totalAmount)
    }
    
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity {
        return data[sectionIndex].cellInfo[cellIndex]
    }
}
