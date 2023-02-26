import UIKit

final class CategoryAdderView: UIView {
    
    // MARK: Private data structures
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 0.5
        
        enum TopContainer {
            static let leftRightIndent: CGFloat = 16
            static let topIndent: CGFloat = 16
            static let height: CGFloat = 24
        }
        enum TitleLabel {
            static let fontHeight: CGFloat = 20
        }
        enum CloseButton {
            static let heightWidth: CGFloat = 24
            struct Image {
                static let height: CGFloat = 10
            }
        }
        enum TextField {
            static let leftRightIndent: CGFloat = 16
            static let topIndent: CGFloat = 16
            static let height: CGFloat = 44
            static let cornerRadius: CGFloat = 10
            static let borderWidth: CGFloat = 0.5
            static let leftRightTextIndent: CGFloat = 8
            static let maxNumberOfCharacters: Int = 18
        }
        enum SaveButton {
            static let leftRightIndent: CGFloat = 16
            static let topIndent: CGFloat = 12
            static let height: CGFloat = 44
            static let cornerRadius: CGFloat = 10
            static let fontHeight: CGFloat = 17
        }
        enum ToolBar {
            static let height: CGFloat = 50
        }
    }
    
    // MARK: Private properties
    
    private let topContainer: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let closeButton: UIButton = UIButton(type: .system)
    private let textField: TextFieldWithInsets = TextFieldWithInsets()
    private let saveButton: UIButton = UIButton(type: .system)
    
    // MARK: Internal properties
    
    var delegate: CategoryAdderViewDelegate?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigurations()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfigurations()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupConstraints()
    }
    
    // MARK: Private
    
    private func setupConfigurations() {
        
        [titleLabel, closeButton].forEach {
            topContainer.addSubview($0)
        }
        
        [topContainer, textField, saveButton].forEach {
            addSubview($0)
        }
        
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.cornerRadius
        
        backgroundColor = .systemBackground
        
        titleLabel.font = .systemFont(ofSize: Constants.TitleLabel.fontHeight, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.text = "Добавить категорию"
        
        textField.delegate = self
        
        closeButton.backgroundColor = .systemGray6
        closeButton.layer.cornerRadius = Constants.CloseButton.heightWidth / 2
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        
        let image = UIImage.init(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: Constants.CloseButton.Image.height, weight: .medium))
        closeButton.tintColor = .systemGray
        closeButton.setImage(image, for: .normal)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.ToolBar.height))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(textFieldDoneAction))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.layer.borderWidth = Constants.TextField.borderWidth
        textField.textColor = .label
        textField.keyboardType = .default
        
        textField.insets = UIEdgeInsets(top: 0, left: Constants.TextField.leftRightTextIndent, bottom: 0, right: Constants.TextField.leftRightTextIndent)
        
        saveButton.layer.cornerRadius = Constants.SaveButton.cornerRadius
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: Constants.SaveButton.fontHeight, weight: .medium)
        saveButton.setTitleColor(.systemBackground, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.TopContainer.leftRightIndent),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.TopContainer.leftRightIndent),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.TopContainer.leftRightIndent),
            topContainer.heightAnchor.constraint(equalToConstant: Constants.TopContainer.height),
            
            titleLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.CloseButton.heightWidth),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.CloseButton.heightWidth),
            
            textField.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: Constants.TextField.topIndent),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.TextField.leftRightIndent),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.TextField.leftRightIndent),
            textField.heightAnchor.constraint(equalToConstant: Constants.TextField.height   ),
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.SaveButton.topIndent),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.SaveButton.leftRightIndent),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.SaveButton.leftRightIndent),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.SaveButton.height),
        ])
    }
    
    @objc
    private func closeButtonTap() {
        textField.text = ""
        endEditing(true)
        delegate?.didTapCloseButton()
    }
    
    @objc
    private func textFieldDoneAction() {
        endEditing(true)
    }
    
    @objc
    private func saveButtonTap() {
        endEditing(true)
        guard let strongText = textField.text else { return }
        delegate?.adderViewWantsToAddNewCategory(categoryTitle: strongText)
        textField.text = ""
    }
    
    // MARK: - Internal
    
    func setFocuse() {
        textField.becomeFirstResponder()
    }
}

extension CategoryAdderView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let strongString = textField.text else { return false }
        let futureString = strongString + string
        
        return futureString.count < Constants.TextField.maxNumberOfCharacters
    }
}
