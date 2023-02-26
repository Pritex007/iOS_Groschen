import Foundation
import UIKit

final class AmountView: UIView {
    
    struct DisplayData {
        let amount: String
        let currencyImage: UIImage?
    }
    
    private enum Constants {
        enum AmountView {
            static let cornerRadius: CGFloat = 13.0
        }
        enum AmountLabel {
            static let leadingIndentFromBackgroundImage: CGFloat = 5.0
            static let trailingIndentFromCurrencyIcon: CGFloat = 2.0
            static let topIndentFromBackgroundImage: CGFloat = 4.0
            
            static var height: CGFloat = 18.0
        }
        enum CurrencyIcon {
            static let defaultImage = UIImage(systemName: "circle.fill")
            
            static let trailingIndentFromBackgroundImage: CGFloat = 4.0
            static let topIndentFromTimeBackgroundImage: CGFloat = 4.0
            
            static let width: CGFloat = 16.0
            static let height: CGFloat = 16.0
        }
        enum Font {
            static let titleTextSize: CGFloat = 17.0
            static let otherTextSize: CGFloat = 15.0
            
        }
        
    }
    
    private let amountLabel = UILabel()
    private let currencyIcon = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func prepareForReuse() {
        amountLabel.text = ""
        currencyIcon.image = Constants.CurrencyIcon.defaultImage
    }
    
    func setupConstraints() {
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: Constants.AmountLabel.leadingIndentFromBackgroundImage),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            // MARK: currencyIcon constraints activation
            currencyIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: -Constants.CurrencyIcon.trailingIndentFromBackgroundImage),
            currencyIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            currencyIcon.widthAnchor.constraint(equalToConstant: Constants.CurrencyIcon.width),
            currencyIcon.heightAnchor.constraint(equalToConstant: Constants.CurrencyIcon.height),
            
            amountLabel.trailingAnchor.constraint(equalTo: currencyIcon.leadingAnchor,
                                                  constant: -Constants.AmountLabel.trailingIndentFromCurrencyIcon)
        ])
    }
    
    func setupViews() {
        addSubview(amountLabel)
        addSubview(currencyIcon)
        
        backgroundColor = .white
        layer.cornerRadius = Constants.AmountView.cornerRadius
        
        amountLabel.textAlignment = .right
        amountLabel.font = UIFont.systemFont(ofSize: Constants.Font.titleTextSize)
        currencyIcon.tintColor = .black
        
    }

    func configure(displayData: DisplayData) {
        amountLabel.text = displayData.amount
        currencyIcon.image = displayData.currencyImage
    }
}
