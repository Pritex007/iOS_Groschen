import UIKit

final class StatisticsDateIntervalCell: UITableViewCell {
    
    // MARK: Internal
    
    struct ConfigureData {
        let title: String
        let description: String
    }
    
    enum CellType: Int {
        case start = 0
        case end = 1
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
        enum DateLabel {
            static let trailingIndent: CGFloat = 8
            static let height: CGFloat = 18
            static let width: CGFloat = 70
            static let fontSize: CGFloat = 17
        }
    }
    
    // MARK: Priavte properties
    
    private let titleLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        dateLabel.text = ""
        separatorInset = UIEdgeInsets(top: 0,
                                      left: Constants.Cell.defaultLeftRightIndent,
                                      bottom: 0,
                                      right: Constants.Cell.defaultLeftRightIndent)
        
    }
    
    // MARK: Internal methods
    
    func configure(configureData: ConfigureData) {
        titleLabel.text = configureData.title
        dateLabel.text = configureData.description
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -Constants.DateLabel.trailingIndent),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupConfigurations() {
        [titleLabel, rightArrow, dateLabel].forEach() { view in
            contentView.addSubview(view)
        }
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        
        dateLabel.font = .systemFont(ofSize: Constants.DateLabel.fontSize, weight: .regular)
        dateLabel.textColor = .systemGray
        dateLabel.textAlignment = .right
        
        rightArrow.tintColor = .label
        rightArrow.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: Constants.RightArrow.height, weight: .medium))
    }
}

// MARK: - DatePickerCellDisplayDataProtocol

extension StatisticsDateIntervalCell: DatePickerCellDisplayDataProtocol {
    func dateChanged(date: Date) {
        dateLabel.text = DateFormatter.dayMonthYearFormatter.string(from: date)
    }
}
