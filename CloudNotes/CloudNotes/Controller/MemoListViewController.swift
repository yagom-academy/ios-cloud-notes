import UIKit

protocol MemoListViewControllerDelegate: AnyObject {
    func memoListViewController(updateTableViewCellWith title: String, body: String, lastModified: Date)
    func deleteTableViewCell()
}

final class MemoListViewController: UIViewController {
    weak var delegate: MemoDetailViewControllerDelegate?
    
    private let cellIdentifier = "Cell"
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MemoDataManager.shared.memos = MemoDataManager.shared.fetchMemos()
        setupTableView()
        setupTableViewLayout()
        setupNavigationBar()
        setupRowSelection()
    }
    
    private func setupTableView() {
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
    
    private func setupRowSelection() {
        if MemoDataManager.shared.isEmpty == false {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
            delegate?.memoDetailViewController(showTextViewWith: MemoDataManager.shared.memos[0])
        }
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.deleteMemo(at: indexPath)
        }
        let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
            self.showActivityView(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func deleteMemo(at indexPath: IndexPath) {
        let deletedMemo = MemoDataManager.shared.memos[indexPath.row]
        MemoDataManager.shared.deleteMemo(id: deletedMemo.id)
        tableView.deleteRows(at: [indexPath], with: .none)
        
        if indexPath.row < MemoDataManager.shared.memos.count {
            let memo = MemoDataManager.shared.memos[indexPath.row]
            delegate?.memoDetailViewController(showTextViewWith: memo)
            tableView.allowsSelectionDuringEditing = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        } else {
            delegate?.showEmptyTextView()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        if indexPath.row < MemoDataManager.shared.memos.count {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    private func showActivityView(indexPath: IndexPath) {
        let memo = MemoDataManager.shared.memos[indexPath.row]
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

// MARK: - MemoListViewControllerDelegate

extension MemoListViewController: MemoListViewControllerDelegate {
    func deleteTableViewCell() {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        deleteMemo(at: indexPath)
    }
    
    func memoListViewController(updateTableViewCellWith title: String, body: String, lastModified: Date) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let id = MemoDataManager.shared.memos[indexPath.row].id else {
            return
        }
        MemoDataManager.shared.updateMemo(id: id, title: title, body: body, lastModified: lastModified)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
}
