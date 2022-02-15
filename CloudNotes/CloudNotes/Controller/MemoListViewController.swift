import UIKit

protocol MemoListViewControllerDelegate: AnyObject {
    func memoListViewController(updateTableViewCellWith memo: Memo)
}

class MemoListViewController: UIViewController {
    weak var delegate: MemoDetailViewControllerDelegate?
    
    private let cellIdentifier = "Cell"
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupTableView()
        setupNavigationBar()
        
        if !MemoDataManager.shared.isEmpty {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    private func setupTableView() {
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
        let newMemo = MemoDataManager.shared.newMemo
        
        MemoDataManager.shared.memos.insert(newMemo, at: 0)
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        delegate?.memoDetailViewController(showTextViewWith: newMemo)
    }
}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoDataManager.shared.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        let memo = MemoDataManager.shared.memos[indexPath.row]
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
        let memo = MemoDataManager.shared.memos[indexPath.row]
        delegate?.memoDetailViewController(showTextViewWith: memo)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            MemoDataManager.shared.memos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let memo = MemoDataManager.shared.memos[indexPath.row]
            self.delegate?.memoDetailViewController(showTextViewWith: memo)
            
            tableView.allowsSelectionDuringEditing = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
}

// MARK: - MemoListViewControllerDelegate

extension MemoListViewController: MemoListViewControllerDelegate {
    func memoListViewController(updateTableViewCellWith memo: Memo) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        MemoDataManager.shared.memos[indexPath.row] = memo
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
}
