import UIKit

final class StatisticsBalanceSelectionCell: UITableViewCell {
    
    // MARK: Internal configure data
    
    struct ConfigureData {
        let title: String
        let amount: String
        let currencyImage: UIImage?
    }
    
    private enum Constants {
        enum Cell {
            static let defaultLeftRightIndent: CGFloat = 16
        }
        enum TitleLabel {
            static let height: CGFloat = 18
            static let width: CGFloat = 70
            static let fontSize: CGFloat = 17
        }
        enum RightArrow {
            static let height: CGFloat = 16
            static let width: CGFloat = 8
        }
        enum QuantityLabel {
            static let trailingIndent: CGFloat = 6
            static let leadingIndent: CGFloat = 8
            static let height: CGFloat = 18
            static let width: CGFloat = 70
            static let fontSize: CGFloat = 17
        }
        
        enum CurrencyImage {
            static let height: CGFloat = 16
            static let width: CGFloat = 16
            static let trailingIndent: CGFloat = 8
        }
    }
    
    // MARK: Private properties
    
    private let titleLabel: UILabel = UILabel()
    private let currencyImage: UIImageView = UIImageView()
    private let quantityLabel: UILabel = UILabel()
    private let rightArrow: UIImageView = UIImageView()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConfigurations()
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConfigurations()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: Constants.Cell.defaultLeftRightIndent,
                                                                     bottom: 0,
                                                                     right: Constants.Cell.defaultLeftRightIndent))
    }
    
    // MARK: Internal methods
    
    func configure(configureData: ConfigureData) {
        titleLabel.text = configureData.title
        quantityLabel.text = configureData.amount
        currencyImage.image = configureData.currencyImage
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyImage.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            currencyImage.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -Constants.CurrencyImage.trailingIndent),
            currencyImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyImage.heightAnchor.constraint(equalToConstant: Constants.CurrencyImage.height),
            currencyImage.widthAnchor.constraint(equalToConstant: Constants.CurrencyImage.width),
            
            quantityLabel.trailingAnchor.constraint(equalTo: currencyImage.leadingAnchor, constant: -Constants.QuantityLabel.trailingIndent),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constants.QuantityLabel.leadingIndent)
        ])
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        quantityLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConfigurations() {
        [titleLabel, rightArrow, quantityLabel, currencyImage].forEach() { view in
            contentView.addSubview(view)
        }
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        
        currencyImage.tintColor = .label
        
        quantityLabel.font = .systemFont(ofSize: Constants.QuantityLabel.fontSize, weight: .regular)
        quantityLabel.textColor = .systemGray
        quantityLabel.textAlignment = .right
        
        rightArrow.tintColor = .label
        rightArrow.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: Constants.RightArrow.height, weight: .medium))
    }
}
