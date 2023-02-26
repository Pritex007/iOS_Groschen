import UIKit

final class StatisticsViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            enum Separator {
                static let leftRightIndent: CGFloat = 16
            }
            
            static let cellHeight: CGFloat = 44
        }
        
        struct IntervalButton {
            static let font: CGFloat = 18
        }
    }
    
    // MARK: Private properties
    
    private let tableView: UITableView = UITableView()
    
    // MARK: Internal properties
    
    var output: StatisticsViewOutput?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Интервал",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(intervalTap))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: Constants.IntervalButton.font,
                                                                                            weight: .regular)],
                                                                  for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        view.backgroundColor = .systemBackground
        
        setupConfigurations()
        setupTable()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output?.viewNeedsData()
    }
    
    // MARK: Private methods
    
    private func setupConfigurations() {
        view.addSubview(tableView)
        
        title = "Статистика"
        view.backgroundColor = .systemBackground
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SelectionCell.self, forCellReuseIdentifier: "SelectionCell")
        tableView.register(StatisticsBalanceSelectionCell.self, forCellReuseIdentifier: "StatisticsBalanceSelectionCell")
        
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
    private func intervalTap() {
        output?.intervalTapped()
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = StatisticsModel.CellType(rawValue: indexPath.row) else { return }
        output?.didTapCell(type: cellType)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = StatisticsModel.CellType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch cellType {
        case .income:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as? SelectionCell,
                  let configureData = output?.configureIncomeCell()
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        case .expense:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as? SelectionCell,
                  let configureData = output?.configureExpenseCell()
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        case .balance:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsBalanceSelectionCell") as? StatisticsBalanceSelectionCell,
                  let configureData = output?.configureBalanceCell()
            else {
                return UITableViewCell()
            }
            cell.configure(configureData: configureData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.cellHeight
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
}

// MARK: - StatisticsViewInput

extension StatisticsViewController: StatisticsViewInput {
    func reloadTable() {
        tableView.reloadData()
    }
}
