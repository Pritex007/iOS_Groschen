import UIKit

final class EditOperationViewController: UIViewController {
    
    // MARK: - Private constants
    
    private enum Constants {
        enum TableView {
            static let rowHeight: CGFloat = 44
            struct Separator {
                static let leftRightIndent: CGFloat = 16
                static let topBottomIndent: CGFloat = 0
            }
            static let commentFontHeight: CGFloat = 17
        }
        
        enum SaveButton {
            static let fontHeight: CGFloat = 18
        }
        
        enum DeleteButton {
            static let height: CGFloat = 44
            static let fontHeight: CGFloat = 17
            static let cornerRadius: CGFloat = 10
            static let trailingIndent: CGFloat = 24
            static let leadingIndent: CGFloat = 24
            static let bottomIndent: CGFloat = 24
        }
    }
    
    private var comment: String = ""
    
    // MARK: - Internal properties
    
    var output: EditOperationViewControllerOutput?
    
    // MARK: - Private properties
    
    private let tableView: UITableView = UITableView()
    private let deleteButton: UIButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let rightButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveOperation))
        rightButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: Constants.SaveButton.fontHeight, weight: .regular)], for: .normal)
        rightButton.tintColor = .systemGreen
        rightButton.isEnabled = false
        navigationItem.rightBarButtonItem = rightButton
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
        [tableView, deleteButton].forEach(view.addSubview(_:))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(AmountFieldCell.self, forCellReuseIdentifier: AmountFieldCell.reuseId)
        tableView.register(NewOperationDatePickerCell.self, forCellReuseIdentifier: NewOperationDatePickerCell.reuseId)
        tableView.register(SelectionCell.self, forCellReuseIdentifier: SelectionCell.reuseId)
        tableView.register(CommentFieldCell.self, forCellReuseIdentifier: CommentFieldCell.reuseId)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0,
                                         left: Constants.TableView.Separator.leftRightIndent,
                                         bottom: 0,
                                         right: Constants.TableView.Separator.leftRightIndent)
        
        tableView.tableFooterView = UIView()
        
        deleteButton.layer.cornerRadius = Constants.DeleteButton.cornerRadius
        deleteButton.backgroundColor = .systemBlue
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: Constants.DeleteButton.fontHeight, weight: .medium)
        deleteButton.setTitleColor(.systemBackground, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteOperation), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.DeleteButton.height),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.DeleteButton.trailingIndent),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.DeleteButton.leadingIndent),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.DeleteButton.bottomIndent),
        ])
    }
    
    // MARK: - Private action methods
    
    @objc
    private func saveOperation() {
        output?.didTapSaveButton()
    }
    
    @objc
    private func deleteOperation() {
        output?.didTapDeleteButton()
    }
}

// MARK: - UITableViewDelegate

extension EditOperationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch NewOperationModel.CellType(rawValue: indexPath.row) {
        case .comment:
            return comment.heightWithConstrainedWidth(width: tableView.frame.width - 2 * Constants.TableView.Separator.leftRightIndent,
                                                      font: .systemFont(ofSize: Constants.TableView.commentFontHeight, weight: .regular))
        default:
            return Constants.TableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellDisplayData = NewOperationModel.CellType(rawValue: indexPath.row) else { return }
        switch cellDisplayData {
        case .amount:
            guard let cell = tableView.cellForRow(at: indexPath) as? AmountFieldCell else { return }
            cell.selectedCell()
        case .category:
            output?.didTapCategory()
        case .date, .dateTime:
            guard let cell = tableView.cellForRow(at: indexPath) as? NewOperationDatePickerCell else { return }
            cell.selectedCell()
        case .comment:
            guard let cell = tableView.cellForRow(at: indexPath) as? CommentFieldCell else { return }
            cell.selectedCell()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension EditOperationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewOperationModel.CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellDisplayData = NewOperationModel.CellType(rawValue: indexPath.row) else { return UITableViewCell() }
        switch cellDisplayData {
        case .amount:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AmountFieldCell.reuseId) as? AmountFieldCell,
                  let configureData = output?.configureAmountCell(),
                  let dataDelegate = output as? CellDataDelegate
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            cell.dataDelegate = dataDelegate
            return cell
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectionCell.reuseId) as? SelectionCell,
                  let configureData = output?.configureCategoryCell()
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        case .date, .dateTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewOperationDatePickerCell.reuseId) as? NewOperationDatePickerCell,
                  let info = output?.configureDatePickerCell(type: cellDisplayData),
                  let dataDelegate = output as? CellDataDelegate
            else {
                return UITableViewCell()
            }
            cell.dataDelegate = dataDelegate
            cell.configure(configureData: info)
            return cell
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentFieldCell.reuseId) as? CommentFieldCell,
                  let configureData = output?.configureCommentCell(),
                  let dataDelegate = output as? CellDataDelegate
            else {
                return UITableViewCell()
            }
            cell.dataDelegate = dataDelegate
            cell.delegate = self
            cell.configure(comment: configureData)
            return cell
        }
    }
}

// MARK: - EditOperationViewControllerInput

extension EditOperationViewController: EditOperationViewControllerInput {
    
    func enableSaveButton() {
        guard let button = navigationItem.rightBarButtonItem else { return }
        button.isEnabled = true
    }
    
    func disableSaveButton() {
        guard let button = navigationItem.rightBarButtonItem else { return }
        button.isEnabled = false
    }
    
    func configureCategory(_ configureData: SelectionCell.ConfigureData) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: NewOperationModel.CellType.category.rawValue, section: 0)) as? SelectionCell
        else {	
            return
        }
        cell.configure(configureData: configureData)
    }
    
    func endEditting() {
        view.endEditing(true)
    }
}

// MARK: - GrowingCellProtocol

extension EditOperationViewController: GrowingCellProtocol {
    func updateHeightOfRow(newText: String) {
        tableView.beginUpdates()
        comment = newText
        tableView.endUpdates()
    }
}
