import UIKit

final class AmountFieldCell: UITableViewCell {
    
    struct ConfigureData {
        let amountString: String?
        let placeholder: String
    }
    
    // MARK: Private Constants
    
    private enum Constants {
        enum Cell {
            static let topBottomIndent: CGFloat = 0
            static let leftRightIndent: CGFloat = 16
        }
        enum ToolBar {
            static let height: CGFloat = 50
        }
        enum TextField {
            static let fontHeight: CGFloat = 17
            static let maxCountOfDigitsAfterDot: Int = 2
            static let maxCountOfSymbols: Int = 13
        }
    }
    
    private let textField: UITextField = UITextField()
    
    // MARK: Internal properties
    
    weak var dataDelegate: CellDataDelegate?
    static let reuseId: String = "AmountFieldCell"
    
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
    
    func configure(configureData: ConfigureData) {
        textField.placeholder = configureData.placeholder
        textField.text = configureData.amountString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.Cell.topBottomIndent,
                                                                     left: Constants.Cell.leftRightIndent,
                                                                     bottom: Constants.Cell.topBottomIndent,
                                                                     right: Constants.Cell.leftRightIndent))
    }
    
    // MARK: Private methods
    
    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupConfigurations() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: Constants.ToolBar.height))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(amountDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        
        contentView.addSubview(textField)
        
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.font =  .systemFont(ofSize: Constants.TextField.fontHeight, weight: .regular)
        textField.attributedPlaceholder = .init(string: textField.placeholder ?? "",
                                                attributes: [.font: UIFont.systemFont(ofSize: Constants.TextField.fontHeight,
                                                                                      weight: .regular),
                                                             .foregroundColor: UIColor.systemGray])
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.autocorrectionType = .no
    }
    
    @objc
    private func amountDone() {
        textField.endEditing(true)
    }
    
    @objc
    private func textChanged() {
        guard let amountString = textField.text?.replacingOccurrences(of: ",", with: "."),
              let amount = Decimal(string: amountString)
        else {
            dataDelegate?.translateAmount(0)
            return
        }
        
        dataDelegate?.translateAmount(amount)
    }
    
    // MARK: Internal methods
    
    func selectedCell() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension AmountFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        guard let strongText = textField.text,
              let separator = NumberFormatter().decimalSeparator,
              var tempString = textField.text
        else { return false }
        
        tempString.insert(contentsOf: string, at: tempString.index(tempString.startIndex, offsetBy: range.location))
        
        if strongText.contains(separator) && string == separator || tempString.count >= Constants.TextField.maxCountOfSymbols {
            return false
        }
        
        if strongText.contains(separator) {
            let limitDecimalPlace = Constants.TextField.maxCountOfDigitsAfterDot
            guard let nowDecimalPlace = strongText.components(separatedBy: separator).last,
                  let futureDecimalPlace = tempString.components(separatedBy: separator).last
            else { return false }
            if futureDecimalPlace.count <= limitDecimalPlace || futureDecimalPlace == nowDecimalPlace {
                return true
            } else {
                return false
            }
        }
        return true
    }
}
