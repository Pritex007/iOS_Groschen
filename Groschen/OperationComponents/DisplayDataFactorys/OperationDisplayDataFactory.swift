import Foundation
import UIKit

protocol OperationDisplayDataFactoryProtocol {
    func operationDisplayData(categoryName: String, commentText: String?, date: Date, amount: Decimal, currency: Int) -> OperationCell.DisplayData
    func amountViewDisplayData(amount: Decimal, currency: Int) -> AmountView.DisplayData
    func sectionHeaderDisplayData(sectionData: OperationSectionData) -> OperationSectionHeader.DisplayData
}


final class OperationDisplayDataFactory: OperationDisplayDataFactoryProtocol {
    func amountViewDisplayData(amount: Decimal, currency: Int) -> AmountView.DisplayData {
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
        switch currency {
        case 643:
            currencyImage = UIImage(systemName: "rublesign.circle.fill")
        case 840:
            currencyImage = UIImage(systemName: "dollarsign.circle.fill")
        case 978:
            currencyImage = UIImage(systemName: "eurosign.circle.fill")
        default:
            currencyImage = UIImage(systemName: "circle.fill")
        }
        
        return AmountView.DisplayData(
            amount: displayAmount,
            currencyImage: currencyImage
        )
    }
    
    func sectionHeaderDisplayData(sectionData: OperationSectionData) -> OperationSectionHeader.DisplayData {
        let date = DateFormatter.sectionDateFormatter.string(from: sectionData.cellInfo[0].dateTime)
        return OperationSectionHeader.DisplayData(
            date: date,
            amount: amountViewDisplayData(amount: sectionData.totalAmount, currency: 643)
        )
    }
    
    func operationDisplayData(categoryName: String, commentText: String?, date: Date, amount: Decimal, currency: Int) -> OperationCell.DisplayData {
        let dateFormatter = DateFormatter.timeFormatter
        let timeString = dateFormatter.string(from: date)
        
        return OperationCell.DisplayData(
            category: categoryName,
            comment: commentText,
            time: timeString,
            amountDisplayData: amountViewDisplayData(amount: amount, currency: currency)
        )
    }
}
