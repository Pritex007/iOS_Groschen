import UIKit

final class StatisticsIntervalViewController: UIViewController {
    
    // MARK: Private constants

    private enum Constants {
        enum TableView {
            enum Separator {
                static let leftRightIndent: CGFloat = 16
            }
            enum Cell {
                static let defaultHeight: CGFloat = 44
            }
            enum DatePcikerCell {
                static let height: CGFloat = 230
            }
        }
        enum DoneButton {
            static let font: CGFloat = 18
        }
    }
    
    // MARK: Internal properties
    
    var output: StatisticsIntervalViewOutput?
    
    // MARK: Private properties
    
    private let tableView: UITableView = UITableView()
    
    private var startDateIsEditing = false
    private let startDatePickerIndexPath = IndexPath(row: 1, section: 1)
    private var endDateIsEditing = false
    private let endDatePickerIndexPath = IndexPath(row: 2, section: 1)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(doneButtonTap))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: Constants.DoneButton.font,
                                                                                            weight: .regular)],
                                                                  for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        setupConfigurations()
        setupTable()
        
        setupConstraints()
    }
    
    // MARK: Private methods
    
    private func setupConfigurations() {
        view.addSubview(tableView)
        
        title = "Интервал"
        view.backgroundColor = .systemBackground
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StatisticsIntervalSelectionCell.self, forCellReuseIdentifier: "StatisticsIntervalSelectionCell")
        tableView.register(StatisticsDateIntervalCell.self, forCellReuseIdentifier: "StatisticsDateIntervalCell")
        tableView.register(StatisticsDatePickerCell.self, forCellReuseIdentifier: "StatisticsDatePickerCell")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray2
        tableView.separatorInset.left = Constants.TableView.Separator.leftRightIndent
        tableView.separatorInset.right = Constants.TableView.Separator.leftRightIndent
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    // MARK: Private action methods
    
    @objc
    private func doneButtonTap() {
        output?.userDidTapDoneButton()
    }
}

// MARK: - UITableViewDataSource

extension StatisticsIntervalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSections = output?.numberOfSections() else {
            return 0
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = output?.numbersOfRow(section, startDateIsEditing || endDateIsEditing)
        else {
            return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            guard let intervalType = StatisticsIntervalSelectionCell.CellType(rawValue: indexPath.row) else { return }
            output?.selectedIntervalType(intervalType)
        } else {
            if indexPath.row == 0
                || indexPath == startDatePickerIndexPath && !startDateIsEditing
                || indexPath == endDatePickerIndexPath && !endDateIsEditing {
                let dateIntervalCellType: StatisticsDateIntervalCell.CellType = indexPath.row == 0 ? .start : .end
                output?.selectedDateIntervalCell(dateIntervalCellType, startDateIsEditing, endDateIsEditing)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsIntervalSelectionCell") as? StatisticsIntervalSelectionCell,
                  let type = StatisticsIntervalSelectionCell.CellType(rawValue: indexPath.row),
                  let configureData = output?.configureIntervalSelectionCell(type)
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        } else {
            if (indexPath.row == 1 && startDateIsEditing) || (indexPath.row == 2 && endDateIsEditing) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsDatePickerCell") as? StatisticsDatePickerCell,
                      let type = StatisticsDatePickerCell.CellType(rawValue: indexPath.row),
                      let configureData = output?.configureDatePickerCell(type: type),
                      let displayDelegate = tableView.cellForRow(at: IndexPath(row: startDateIsEditing ? 0 : indexPath.row - 1, section: 1)) as? DatePickerCellDisplayDataProtocol
                else {
                    return UITableViewCell()
                }
                cell.displayDelegate = displayDelegate
                cell.transferDelegate = self
                cell.configure(configureData: configureData)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsDateIntervalCell") as? StatisticsDateIntervalCell,
                  let type = StatisticsDateIntervalCell.CellType(rawValue: indexPath.row),
                  let configureData = output?.configureIntervalDateCell(type: type)
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard (indexPath == startDatePickerIndexPath && startDateIsEditing) || (indexPath == endDatePickerIndexPath && endDateIsEditing) else {
            return Constants.TableView.Cell.defaultHeight
        }
        return Constants.TableView.DatePcikerCell.height
    }
}

// MARK: - UITableViewDelegate

extension StatisticsIntervalViewController: UITableViewDelegate {
}

// MARK: - StatisticsIntervalSelectionViewOutput

extension StatisticsIntervalViewController: StatisticsIntervalViewInput {
    func enableDoneButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func disableDoneButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func markCell(_ index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        cell?.accessoryType = .checkmark
    }
    
    func unMarkCell(_ index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        cell?.accessoryType = .none
    }
    
    func addCustomIntervalSection() {
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integer: 1), with: .fade)
        tableView.insertRows(at: [
            IndexPath(row: 0, section: 1),
            IndexPath(row: 1, section: 1)
        ],
        with: .fade)
        tableView.endUpdates()
    }
    
    func deleteCustomIntervalSection() {
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: 1), with: .fade)
        var rowArray = [
            IndexPath(row: 0, section: 1),
            IndexPath(row: 1, section: 1),
        ]
        if startDateIsEditing || endDateIsEditing {
            rowArray.append(IndexPath(row: 2, section: 1))
        }
        tableView.deleteRows(at: rowArray,
                             with: .fade)
        startDateIsEditing = false
        endDateIsEditing = false
        tableView.endUpdates()
    }
    
    func deleteStartDatePickerCell() {
        tableView.beginUpdates()
        tableView.deleteRows(at: [startDatePickerIndexPath], with: .fade)
        guard let startDateHeaderCell = tableView.cellForRow(at: IndexPath(row: startDatePickerIndexPath.row - 1, section: 1)) else { return }
        startDateHeaderCell.separatorInset.left = Constants.TableView.Separator.leftRightIndent
        startDateIsEditing = false
        tableView.endUpdates()
    }
    
    func addStartDatePickerCell() {
        tableView.beginUpdates()
        guard let startDateHeaderCell = tableView.cellForRow(at: IndexPath(row: startDatePickerIndexPath.row - 1, section: 1)) else { return }
        tableView.insertRows(at: [startDatePickerIndexPath], with: .fade)
        startDateHeaderCell.separatorInset.left = .greatestFiniteMagnitude
        startDateIsEditing = true
        tableView.endUpdates()
    }
    
    func deleteEndDatePickerCell() {
        tableView.beginUpdates()
        tableView.deleteRows(at: [endDatePickerIndexPath], with: .fade)
        guard let endDateHeaderCell = tableView.cellForRow(at: IndexPath(row: endDatePickerIndexPath.row - 1, section: 1)) else { return }
        endDateHeaderCell.separatorInset.left = Constants.TableView.Separator.leftRightIndent
        endDateIsEditing = false
        tableView.endUpdates()
    }
    
    func addEndDatePickerCell() {
        tableView.beginUpdates()
        guard let endDateHeaderCell = tableView.cellForRow(at: IndexPath(row: endDatePickerIndexPath.row - 1, section: 1)) else { return }
        tableView.insertRows(at: [endDatePickerIndexPath], with: .fade)
        endDateHeaderCell.separatorInset.left = .greatestFiniteMagnitude
        endDateIsEditing = true
        tableView.endUpdates()
    }
}

// MARK: - DatePickerCellDataTransferDelegate

extension StatisticsIntervalViewController: DatePickerCellDataTransferDelegate {
    func startDateChanged(_ date: Date) -> Date {
        guard let date = output?.selectedStartDate(date) else { return Date() }
        return date
    }
    
    func endDateChanged(_ date: Date) -> Date {
        guard let date = output?.selectedEndDate(date) else { return Date() }
        return date
    }
}
