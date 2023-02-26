import UIKit

final class CategoryScreenViewController: UIViewController {
    
    private let keyboardAwareBottomLayoutGuide: UILayoutGuide = UILayoutGuide()
    private var keyboardTopAnchorConstraint: NSLayoutConstraint?
    private var adderViewBottomConstraint: NSLayoutConstraint?
    
    private let adderView: CategoryAdderView = CategoryAdderView()
    
    private enum Constants {
        enum TableView {
            enum Separator {
                static let leftRightIndent: CGFloat = 16
                static let topBottomIndent: CGFloat = 0
            }
            enum Cell {
                static let rowHeight: CGFloat = 44
            }
        }
        enum AdderView {
            static let leftRightIndent: CGFloat = 8
            static let bottomIndent: CGFloat = 8
            static let height: CGFloat = 172
        }
    }
    
    var output: CategoryScreenViewOutput?
    
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adderView.isHidden = true
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addNewCategory))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        setupKeyboard()
        setupConfigurations()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output?.viewWillAppear()
    }
    
    private func setupConfigurations() {
        view.addSubview(tableView)
        view.addSubview(adderView)
        
        adderView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CategoryScreenCell.self, forCellReuseIdentifier: "CategoryScreenCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: Constants.TableView.Separator.topBottomIndent,
                                         left: Constants.TableView.Separator.leftRightIndent,
                                         bottom: Constants.TableView.Separator.topBottomIndent,
                                         right: Constants.TableView.Separator.leftRightIndent)
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        adderView.translatesAutoresizingMaskIntoConstraints = false
        
        let adderViewBottomConstraint = adderView.bottomAnchor.constraint(equalTo: keyboardAwareBottomLayoutGuide.topAnchor, constant: Constants.AdderView.height)
        self.adderViewBottomConstraint = adderViewBottomConstraint
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: adderView.topAnchor),
            
            adderView.heightAnchor.constraint(equalToConstant: Constants.AdderView.height),
            adderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.AdderView.leftRightIndent),
            adderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.AdderView.leftRightIndent),
            adderViewBottomConstraint,
        ])
    }
    
    @objc
    private func addNewCategory() {
        adderView.isHidden = false
        adderViewBottomConstraint?.constant = -Constants.AdderView.bottomIndent
        UIView.animate(withDuration: 0.5) {
            self.adderView.setFocuse()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupKeyboard() {
        view.addLayoutGuide(keyboardAwareBottomLayoutGuide)
        keyboardTopAnchorConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: keyboardAwareBottomLayoutGuide.topAnchor, constant: 0)
        keyboardTopAnchorConstraint?.isActive = true
        keyboardAwareBottomLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func hideAdderView() {
        adderViewBottomConstraint?.constant = Constants.AdderView.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] isDone in
            guard isDone else { return }
            self?.adderView.isHidden = true
        }
    }
    
    @objc
    fileprivate func keyboardWillShowNotification(notification: NSNotification) {
        updateKeyboardAwareBottomLayoutGuide(with: notification, hiding: false)
    }
    
    @objc
    fileprivate func keyboardWillHideNotification(notification: NSNotification) {
        updateKeyboardAwareBottomLayoutGuide(with: notification, hiding: true)
    }
    
    fileprivate func updateKeyboardAwareBottomLayoutGuide(with notification: NSNotification, hiding: Bool) {
        let userInfo = notification.userInfo
        
        let animationDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        let keyboardEndFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let rawAnimationCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value
        
        guard let animDuration = animationDuration,
              let keybrdEndFrame = keyboardEndFrame,
              let rawAnimCurve = rawAnimationCurve else {
            return
        }
        
        let convertedKeyboardEndFrame = view.convert(keybrdEndFrame, from: view.window)
        
        let rawAnimCurveAdjusted = UInt(rawAnimCurve << 16)
        let animationCurve = UIView.AnimationOptions(rawValue: rawAnimCurveAdjusted)
        
        keyboardTopAnchorConstraint?.constant = hiding ? 0 : convertedKeyboardEndFrame.height - (tabBarController?.tabBar.frame.height ?? 0)
        
        view.setNeedsLayout()
        
        UIView.animate(withDuration: animDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UITableViewDelegate

extension CategoryScreenViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension CategoryScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = output?.getNumberOfCategories() else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.Cell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.userSelectedCategory(categoryIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryScreenCell") as? CategoryScreenCell,
              let displayData = output?.configurCell(index: indexPath.row)
        else { return UITableViewCell() }
        
        cell.configure(displayData)
        return cell
    }
}

// MARK: - CategoryViewInput

extension CategoryScreenViewController: CategoryScreenViewInput {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func markCell(_ cellForRowAt: Int) {
        tableView.cellForRow(at: IndexPath(row: cellForRowAt, section: 0))?.accessoryType = .checkmark
    }
    
    func unmarkCell(_ cellForRowAt: Int) {
        tableView.cellForRow(at: IndexPath(row: cellForRowAt, section: 0))?.accessoryType = .none
    }
}

// MARK: - CategoryAdderViewDelegate

extension CategoryScreenViewController: CategoryAdderViewDelegate {
    func didTapCloseButton() {
        hideAdderView()
    }
    
    func adderViewWantsToAddNewCategory(categoryTitle: String) {
        output?.addNewCategory(categoryTitle: categoryTitle)
        hideAdderView()
    }
}
