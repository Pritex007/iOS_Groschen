import UIKit

final class OperationSectionHeader: UITableViewHeaderFooterView {
    
    struct DisplayData {
        let date: String
        let amount: AmountView.DisplayData
    }
    
    private enum Constants {
        enum DateLabel {
            static let fontHeight: CGFloat = 17
            static let height: CGFloat = 18
        }
        enum AmountView {
            static let leadingIndexnt: CGFloat = 8
            static let height: CGFloat = 25
        }
    }
    
    private let dateLabel: UILabel = UILabel()
    private let amountView: AmountView = AmountView()
    
    
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
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    private func setupConfigurations() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountView)
        
        dateLabel.font = .systemFont(ofSize: Constants.DateLabel.fontHeight, weight: .regular)
        dateLabel.textColor = .label
        dateLabel.textAlignment = .center
        
        amountView.backgroundColor = .systemGray6
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView?.backgroundColor = .systemBackground
    }
    
    func configure(date: String, amount: AmountView.DisplayData) {
        dateLabel.text = date
        amountView.configure(displayData: amount)
    }
    
    private func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        amountView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: Constants.DateLabel.height),
            
            amountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountView.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: Constants.AmountView.leadingIndexnt),
            amountView.heightAnchor.constraint(equalToConstant: Constants.AmountView.height),
            amountView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
