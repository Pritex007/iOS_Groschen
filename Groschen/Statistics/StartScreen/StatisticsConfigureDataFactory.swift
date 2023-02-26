import UIKit

protocol StatisticsConfigureDataFactoryProtocol {
    func configureIncomeSelectionCell(count: Int) -> SelectionCell.ConfigureData
    func configureExpenseSelectionCell(count: Int) -> SelectionCell.ConfigureData
    func configureBalanceSelectionCell(amount: Decimal, currencyIndex: Int) -> StatisticsBalanceSelectionCell.ConfigureData
}

final class StatisticsConfigureDataFactory: StatisticsConfigureDataFactoryProtocol {
    func configureIncomeSelectionCell(count: Int) -> SelectionCell.ConfigureData {
        return SelectionCell.ConfigureData(title: "Доход",
                                           description: String(count))
    }
    
    func configureExpenseSelectionCell(count: Int) -> SelectionCell.ConfigureData {
        return SelectionCell.ConfigureData(title: "Расход",
                                           description: String(count))
    }
    
    func configureBalanceSelectionCell(amount: Decimal, currencyIndex: Int) -> StatisticsBalanceSelectionCell.ConfigureData {
        let formatter = NumberFormatter.moneyFormatter
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        let displayAmount: String
        if let stringAmount = formatter.string(from: NSDecimalNumber(decimal: amount)) {
            displayAmount = stringAmount
        } else {
            displayAmount = ""
        }
        
        let currencyImage: UIImage?
        switch currencyIndex {
        case 643:
            currencyImage = UIImage(systemName: "rublesign.circle.fill")
        case 840:
            currencyImage = UIImage(systemName: "dollarsign.circle.fill")
        case 978:
            currencyImage = UIImage(systemName: "eurosign.circle.fill")
        default:
            currencyImage = UIImage(systemName: "circle.fill")
        }
        
        return StatisticsBalanceSelectionCell.ConfigureData(title: "Баланс",
                                                            amount: displayAmount,
                                                            currencyImage: currencyImage)
    }
}
