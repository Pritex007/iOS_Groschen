import UIKit

final class CategoryScreenCell: UITableViewCell {
    
    struct DisplayData {
        let title: String
        let marked: Bool
    }
    
    private enum Constants {
        enum Cell {
            static let leftRightIndent: CGFloat = 16
        }
        enum TitleLabel {
            static let fontSize: CGFloat = 17
        }
    }
    
    private let titleLabel: UILabel = UILabel()
    
    var categoryText: String {
        get {
            return titleLabel.text ?? ""
        }
    }
    
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
    
    func configure(_ displayData: DisplayData) {
        titleLabel.text = displayData.title
        accessoryType = displayData.marked ? .checkmark : .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: Constants.Cell.leftRightIndent,
                                                                     bottom: 0,
                                                                     right: Constants.Cell.leftRightIndent))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupConfigurations() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        
        titleLabel.text = "Категория"
    }
}
