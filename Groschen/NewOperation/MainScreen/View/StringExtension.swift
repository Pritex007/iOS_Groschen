import UIKit

extension String {
    private enum Constants {
        enum HeightWithConstrainedWidth {
            static let topIndent: CGFloat = 30
            static let bottomIndent: CGFloat = 10
        }
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height + Constants.HeightWithConstrainedWidth.topIndent + Constants.HeightWithConstrainedWidth.bottomIndent
    }
}
