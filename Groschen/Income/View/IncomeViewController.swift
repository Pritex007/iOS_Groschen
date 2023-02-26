import UIKit

final class IncomeViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            static let leftRightIndent: CGFloat = 16
            static let rowHeight: CGFloat = 72
            static let sectionHeight: CGFloat = 58
        }
    }
    
    private let tableView: UITableView = UITableView()
    
    var output: IncomeViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addNewIncome))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        title = "Доходы"
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output?.viewWillAppear()
    }
    
    @objc
    private func addNewIncome() {
        output?.addNewIncome()
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

// MARK: - IncomeViewInput

extension IncomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.userDidSelectIncomeCell(at: indexPath)
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

// MARK: - IncomeViewInput

extension IncomeViewController: UITableViewDelegate {
    
}

// MARK: - IncomeViewInput

extension IncomeViewController: IncomeViewInput {
    func reloadTable() {
        tableView.reloadData()
    }
}
