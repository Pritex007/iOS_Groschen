import UIKit

final class ExpenseViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            static let leftRightIndent: CGFloat = 16
            static let rowHeight: CGFloat = 72
            static let sectionHeight: CGFloat = 58
        }
    }
    
    private let tableView: UITableView = UITableView()
    
    var output: ExpenseViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Расходы"
        view.backgroundColor = .systemBackground
        
        setupNavigationItem()
        
        setupTable()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output?.viewWillAppear()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addNewExpense))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc
    private func addNewExpense() {
        output?.addNewExpense()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OperationCell.self, forCellReuseIdentifier: "OperationCell")
        tableView.register(OperationSectionHeader.self, forHeaderFooterViewReuseIdentifier: "OperationSectionHeader")
        
        tableView.separatorStyle = .none
        
        if #available(iOS 15.0, *) {
          tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}

// MARK: - ExpenseViewInput

extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.userDidSelectExpenseCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = output?.getNumberOfCellsInSection(index: section) else { return 0 }
        return result
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let result = output?.getNumberOfSections() else { return 0 }
        return result
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.TableView.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OperationSectionHeader") as? OperationSectionHeader,
              let result = output?.configureSectionHeader(index: section)
        else { return UIView() }
        header.configure(date: result.date, amount: result.amount)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationCell else { return UITableViewCell() }
        guard let displayData = output?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section) else { return UITableViewCell() }
        cell.configure(displayData: displayData)
        return cell
    }
}

// MARK: - ExpenseViewInput

extension ExpenseViewController: UITableViewDelegate {
    
}

// MARK: - ExpenseViewInput

extension ExpenseViewController: ExpenseViewInput {
    func reloadTable() {
        tableView.reloadData()
    }
}
