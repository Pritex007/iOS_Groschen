import UIKit

final class NewOperationDatePickerCell: UITableViewCell {
    
    struct ConfigureData {
        let title: String
        let description: String
        let date: Date
        let datePickerMode: UIDatePicker.Mode
        let localeId: String
        let dateFormatter: DateFormatter?
        let translateDataClosure: ((_ delegate: CellDataDelegate?, _ data: Any) -> Void)?
    }
    
    private enum Constants {
        enum DatePicker {
            static let height: CGFloat = 300
        }
        enum Cell {
            static let topBottomIndent: CGFloat = 0
            static let leftRightIndent: CGFloat = 16
        }
        
        static let defaultLeftRightIndent: CGFloat = 16
        
        enum TitleLabel {
            static let height: CGFloat = 18
            static let width: CGFloat = 100
            static let fontSize: CGFloat = 17
        }
        enum RightArrow {
            static let height: CGFloat = 16
            static let width: CGFloat = 8
        }
        enum DescriptionTextField {
            static let leadingIndent: CGFloat = 8
            static let trailingIndent: CGFloat = 8
            static let height: CGFloat = 18
            static let width: CGFloat = 100
            static let fontSize: CGFloat = 17
        }
    }
    
    private let titleLabel: UILabel = UILabel()
    private let descriptionTextField: UITextField = UITextField()
    private let rightArrow: UIImageView = UIImageView()
    
    private var dateFormatter: DateFormatter?
    private var datePicker: UIDatePicker = UIDatePicker()
    private var translateDataClosure: ((_ delegate: CellDataDelegate?, _ data: Any) -> Void)?
    
    weak var dataDelegate: CellDataDelegate?
    static let reuseId: String = "NewOperationDatePickerCell"
    
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
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.Cell.topBottomIndent,
                                                                     left: Constants.Cell.leftRightIndent,
                                                                     bottom: Constants.Cell.topBottomIndent,
                                                                     right: Constants.Cell.leftRightIndent))
    }
    
    func selectedCell() {
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.becomeFirstResponder()
    }

    func configure(configureData: NewOperationDatePickerCell.ConfigureData) {
        titleLabel.text = configureData.title
        descriptionTextField.text = configureData.description
        dateFormatter = configureData.dateFormatter
        datePicker.datePickerMode = configureData.datePickerMode
        datePicker.locale = Locale(identifier: configureData.localeId)
        translateDataClosure = configureData.translateDataClosure
    }
    
    private func setupDatePicker() {
        
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.DescriptionTextField.leadingIndent),
            descriptionTextField.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -Constants.DescriptionTextField.trailingIndent),
            descriptionTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        rightArrow.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        descriptionTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConfigurations() {
        
        [titleLabel, rightArrow, descriptionTextField].forEach() { view in
            contentView.addSubview(view)
        }
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontSize, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        
        descriptionTextField.font = .systemFont(ofSize: Constants.DescriptionTextField.fontSize, weight: .regular)
        descriptionTextField.textColor = .systemGray
        descriptionTextField.textAlignment = .right
        descriptionTextField.tintColor = .clear
        descriptionTextField.delegate = self
        descriptionTextField.autocorrectionType = .no
        descriptionTextField.isUserInteractionEnabled = false
        descriptionTextField.inputView = datePicker
        
        rightArrow.tintColor = .label
        rightArrow.image = UIImage(systemName: "chevron.forward",
                                   withConfiguration: UIImage.SymbolConfiguration.init(pointSize: Constants.RightArrow.height,
                                                                                       weight: .medium))
        
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.backgroundColor = .systemGray6
        datePicker.frame = CGRect(x: datePicker.frame.minX,
                                  y: datePicker.frame.minY + Constants.DatePicker.height,
                                  width: datePicker.frame.width,
                                  height: Constants.DatePicker.height)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc
    private func dateChanged() {
        descriptionTextField.text = dateFormatter?.string(from: datePicker.date)
        translateDataClosure?(dataDelegate, datePicker.date)
    }
}

// MARK: - UITextFieldDelegate

extension NewOperationDatePickerCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        descriptionTextField.isUserInteractionEnabled = false
        return true
    }
}
