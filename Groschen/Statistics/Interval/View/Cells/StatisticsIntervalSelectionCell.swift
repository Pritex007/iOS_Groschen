import UIKit

final class StatisticsIntervalSelectionCell: UITableViewCell {
    
    // MARK: Internal
    
    struct ConfigureData {
        let title: String
        let isMarked: Bool
    }

    enum CellType: Int {
        case month = 0
        case year = 1
        case custom = 2
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
    }
    
    // MARK: Private properties
    
    private let titleLabel: UILabel = UILabel()
    
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
    }
    
    // MARK: Internal methods
    
    func configure(configureData: ConfigureData) {
        titleLabel.text = configureData.title
        accessoryType = configureData.isMarked ? .checkmark : .none
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupConfigurations() {
        [titleLabel].forEach() { view in
            contentView.addSubview(view)
        }
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
    }
}
