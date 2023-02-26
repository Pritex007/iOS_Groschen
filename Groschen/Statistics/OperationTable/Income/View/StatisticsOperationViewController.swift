import UIKit

final class StatisticsOperationViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            static let leftRightIndent: CGFloat = 16
            static let rowHeight: CGFloat = 72
            static let sectionHeight: CGFloat = 58
        }
        enum IntervalButton {
            static let font: CGFloat = 18
        }
    }
    
    // MARK: Private properties
    
    private let tableView: UITableView = UITableView()
    
    // MARK: Internal properties
    
    var output: StatisticsOperationViewOutput?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output?.viewWillAppear()
    }
    
    // MARK: Private methods
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OperationCell.self, forCellReuseIdentifier: "OperationCell")
        tableView.register(StatisticsOperationSectionHeader.self, forHeaderFooterViewReuseIdentifier: "StatisticsOperationSectionHeader")
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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

// MARK: - UITableViewDataSource

extension StatisticsOperationViewController: UITableViewDataSource {
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
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StatisticsOperationSectionHeader") as? StatisticsOperationSectionHeader,
              let result = output?.configureSectionHeader(index: section)
        else { return UIView() }
        header.configure(title: result.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationCell else { return UITableViewCell() }
        guard let displayData = output?.configureCell(cellIndex: indexPath.row, sectionIndex: indexPath.section) else { return UITableViewCell() }
        cell.configure(displayData: displayData)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatisticsOperationViewController: UITableViewDelegate {
    
}

// MARK: - StatisticsOperationViewInput

extension StatisticsOperationViewController: StatisticsOperationViewInput {
    func reloadTable() {
        tableView.reloadData()
    }
}
