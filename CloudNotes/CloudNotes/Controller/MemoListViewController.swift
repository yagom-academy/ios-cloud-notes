import UIKit

protocol MemoListViewControllerDelegate: AnyObject {
    var numberOfMemos: Int { get }
    func getMemo(for indexPath: IndexPath) -> Memo
    func selectFirstMemo()
    func addNewMemo()
    func deleteSelectedMemo(at indexPath: IndexPath)
    func showMemo()
}

final class MemoListViewController: UIViewController {
    weak var delegate: MemoListViewControllerDelegate?
    private let cellIdentifier = "Cell"
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegateAndCell()
        setupTableViewLayout()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.selectFirstMemo()
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
        delegate?.addNewMemo()
    }
}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfMemos ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let memo = delegate!.getMemo(for: indexPath)
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
        delegate?.showMemo()
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.delegate?.deleteSelectedMemo(at: indexPath)
        }
        let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
            self.showActivityView(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath,
              let delegate = delegate else {
                  return
              }
        if indexPath.row < delegate.numberOfMemos {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    private func showActivityView(indexPath: IndexPath) {
        guard let memo = delegate?.getMemo(for: indexPath) else {
            return
        }
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

extension MemoListViewController {
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
