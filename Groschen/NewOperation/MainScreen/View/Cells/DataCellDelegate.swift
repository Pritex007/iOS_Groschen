import Foundation

protocol CellDataDelegate: AnyObject {
    func translateAmount(_ amount: Decimal)
    func translateDate(_ date: Date)
    func translateTime(_ time: Date)
    func translateComment(_ comment: String)
}
