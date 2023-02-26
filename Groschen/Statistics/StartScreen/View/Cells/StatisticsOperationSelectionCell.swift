import UIKit

final class SelectionCell: UITableViewCell {
    
    // MARK: Internal configure data
    
    struct ConfigureData {
        let title: String
        let description: String?
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
        enum DescriptionLabel {
            static let trailingIndent: CGFloat = 8
            static let leadingIndent: CGFloat = 8
            static let height: CGFloat = 18
            static let width: CGFloat = 70
            static let fontSize: CGFloat = 17
        }
    }

    static let reuseId: String = "SelectionCell"
    
    // MARK: Private properties
    
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
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
        descriptionLabel.text = configureData.description
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -Constants.DescriptionLabel.trailingIndent),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.DescriptionLabel.leadingIndent),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        rightArrow.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupConfigurations() {
        [titleLabel, rightArrow, descriptionLabel].forEach() { view in
            contentView.addSubview(view)
        }
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        
        descriptionLabel.font = .systemFont(ofSize: Constants.DescriptionLabel.fontSize, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.textAlignment = .right
        
        rightArrow.tintColor = .label
        rightArrow.image = UIImage(systemName: "chevron.forward",
                                   withConfiguration: UIImage.SymbolConfiguration.init(pointSize: Constants.RightArrow.height,
                                                                                       weight: .medium))
    }
}
