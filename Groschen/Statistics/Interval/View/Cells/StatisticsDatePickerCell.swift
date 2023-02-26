import UIKit

final class StatisticsDatePickerCell: UITableViewCell {
    
    // MARK: Internal
    
    struct ConfigureData {
        let date: Date
        let dateChangeAction: (_ delegate: DatePickerCellDataTransferDelegate, _ date: Date) -> Date
    }
    
    enum CellType: Int {
        case startDatePicker = 1
        case endDatePicker = 2
    }
    
    private enum Constants {
        enum Cell {
            static let defaultLeftRightIndent: CGFloat = 16
        }
    }
    
    // MARK: Priavte properties
    
    private var changeAction: ((_ delegate: DatePickerCellDataTransferDelegate, _ date: Date) -> Date)?
    private let datePicker: UIDatePicker = UIDatePicker()
    
    // MARK: Internal properties
    
    weak var transferDelegate: DatePickerCellDataTransferDelegate?
    weak var displayDelegate: DatePickerCellDisplayDataProtocol?
    
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
        datePicker.date = Date()
        transferDelegate = nil
        displayDelegate = nil
    }
    
    // MARK: Internal methods
    
    func configure(configureData: ConfigureData) {
        datePicker.date = configureData.date
        changeAction = configureData.dateChangeAction
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupConfigurations() {
        [datePicker].forEach { view in
            contentView.addSubview(view)
            
            selectionStyle = .none
            
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = .systemGray6
            datePicker.backgroundColor = .systemBackground
            
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        }
    }
    
    // MARK: Private action methods
    
    @objc
    private func dateChanged() {
        guard let strongDelegate = transferDelegate,
              let date = changeAction?(strongDelegate, datePicker.date)
        else {
            return
        }
        datePicker.date = date
        displayDelegate?.dateChanged(date: date)
    }
}
 
