import UIKit

final class MemoListViewController: UIViewController {
    private let dataManager: MemoDataManager
    private let cellIdentifier = "Cell"
    private let tableView = UITableView()
    
    init(dataManager: MemoDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegateAndCell()
        setupTableViewLayout()
        setupNavigationBar()
        dataManager.listDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let splitViewController = splitViewController as? SplitViewController else {
            return
        }
        super.viewDidAppear(animated)
        splitViewController.selectFirstMemo()
    }
    
    private func setupTableViewDelegateAndCell() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "메모"
    }
    
    @objc private func addMemo() {
        guard let splitViewController = splitViewController as? SplitViewController else {
            return
        }
        splitViewController.addNewMemo()
    }
}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let memo = dataManager.memos[indexPath.row]
        configuration.text = memo.title.isEmpty ? "새로운 메모" : memo.title
        configuration.secondaryAttributedText = memo.subtitle
        configuration.textProperties.numberOfLines = 1
        configuration.secondaryTextProperties.numberOfLines = 1
        configuration.textProperties.adjustsFontForContentSizeCategory = true
        configuration.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitViewController = splitViewController as? SplitViewController else {
            return
        }
        splitViewController.showMemo()
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            guard let splitViewController = self.splitViewController as? SplitViewController else {
                return
            }
            splitViewController.deleteSelectedMemo(at: indexPath)
        }
        let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
            self.showActivityView(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        if indexPath.row < dataManager.memos.count {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    private func showActivityView(indexPath: IndexPath) {
        let memo = dataManager.memos[indexPath.row]
        let title = memo.title ?? ""
        let body = memo.body ?? ""
        let memoToShare = "\(title)\n\(body)"
        let activityViewController = UIActivityViewController(activityItems: [memoToShare], applicationActivities: nil)
        
        if let popOver = activityViewController.popoverPresentationController,
           let splitViewController = splitViewController {
            popOver.sourceView = splitViewController.view
            popOver.sourceRect = CGRect(x: splitViewController.view.bounds.midX,
                                        y: splitViewController.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popOver.permittedArrowDirections = []
        }
        present(activityViewController, animated: true)
    }
}

// MARK: - MemoDataManagerListDelegate

extension MemoListViewController: MemoDataManagerListDelegate {
    var selectedCellIndex: IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    func setupRowSelection() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    func addNewCell() {
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .none)
    }
    
    func selectNextCell(at indexPath: IndexPath) {
        tableView.allowsSelectionDuringEditing = true
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    func updateCell(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
}
