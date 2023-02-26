import UIKit

final class StatisticsOperationSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: Internal display data
    
    struct DisplayData {
        let title: String
    }
    
    private enum Constants {
        enum DateLabel {
            static let fontHeight: CGFloat = 17
            static let height: CGFloat = 18
        }
        static let leftIndent: CGFloat = 16
        static let rightIndent: CGFloat = 16
    }
    
    // MARK: Private properties
    
    private let dateLabel: UILabel = UILabel()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupConfigurations()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConfigurations()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: Constants.leftIndent,
                                                                     bottom: 0,
                                                                     right: Constants.rightIndent))
    }
    
    // MARK: Internal method
    
    func configure(title: String) {
        dateLabel.text = title
    }
    
    // MARK: Private methods
    
    private func setupConfigurations() {
        contentView.addSubview(dateLabel)
        
        dateLabel.font = .systemFont(ofSize: Constants.DateLabel.fontHeight, weight: .regular)
        dateLabel.textColor = .label
        dateLabel.textAlignment = .center
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView?.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: Constants.DateLabel.height)
        ])
    }
}
