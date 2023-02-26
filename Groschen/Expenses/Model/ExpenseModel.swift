import Foundation

final class ExpenseModel {
    
    weak var output: ExpenseModelOutput?
    
    private var data: [OperationSectionData] = []
}

// MARK: - ExpenseModelInput

extension ExpenseModel: ExpenseModelInput {
    
    func loadData(data: [OperationSectionData]) {
        self.data = data
        output?.dataChanged()
    }
    
    func getNumberOfCellsInSection(index: Int) -> Int {
        return data[index].cellInfo.count
    }
    
    func getNumberOfSections() -> Int {
        return data.count
    }
    
    func configureSectionHeader(index: Int) -> OperationSectionData {
        return data[index]
    }
    
    func configureCell(cellIndex: Int, sectionIndex: Int) -> OperationEntity {
        return data[sectionIndex].cellInfo[cellIndex]
    }
}
