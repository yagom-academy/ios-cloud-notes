import UIKit

class MemoListViewController: UITableViewController {
    enum Constant {
        static let navigationTitle = "메모"
        static let lastModified = "lastModified"
        static let id = "id"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpNavigationItem()
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    func updateData(at index: Int) {
        guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
            return
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: .zero)], with: .none)
        tableView.selectRow(at: IndexPath(row: .zero, section: .zero), animated: false, scrollPosition: .middle)
    }
    
    func moveCell(at index: Int) {
        let newIndexPath = IndexPath(row: .zero, section: .zero)
        tableView.moveRow(
            at: IndexPath(row: index, section: .zero),
            to: newIndexPath
        )
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = Constant.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tappedAddButton)
        )
    }
    
    @objc private func tappedAddButton() {
        let newMemo: [String : Any] = [
            Constant.lastModified: Date().timeIntervalSince1970,
            Constant.id: UUID()
        ]
        MemoDataManager.shared.insert(items: newMemo)
        insertCell()
    }
    
    func insertCell() {
        guard let splitVC = self.splitViewController as? SplitViewController,
              let newData = MemoDataManager.shared.fetch()?.first else {
            return
        }
        MemoDataManager.shared.insertMemoList(newData)
        splitVC.present(at: .zero)
        let newIndexPath = IndexPath(row: .zero, section: .zero)
        tableView.insertRows(at: [newIndexPath], with: .fade)
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
    }
}

// MARK: - DataSource
extension MemoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoDataManager.shared.memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MemoListCell.identifier,
            for: indexPath
        ) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.configure(with: MemoDataManager.shared.memoList[safe: indexPath.row])
        return cell
    }
}

// MARK: - Delegate
extension MemoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        splitVC.present(at: indexPath.row)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, completeHandeler in
            self.deleteCell(indexPath: indexPath)
            completeHandeler(true)
        }
        let shareAction = UIContextualAction(style: .normal, title: "share") { _, _, completeHandeler in
            guard let splitVC = self.splitViewController as? SplitViewController else {
                return
            }
            self.showActivityViewController(
                view: splitVC,
                data: MemoDataManager.shared.memoList[indexPath.row].body ?? ""
            )
            completeHandeler(true)
        }
        shareAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func deleteCell(indexPath: IndexPath) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        let item = MemoDataManager.shared.removeMemoList(at: indexPath.row)
        MemoDataManager.shared.delete(item)
        splitVC.clearMemoTextView()
        tableView.deleteRows(at: [indexPath], with: .fade)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let index = indexPath.row == 0 ? 0 : indexPath.row - 1
            let newindexPath = IndexPath(row: index, section: .zero)
            splitVC.present(at: index)
            guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
                return
            }
            self.tableView.selectRow(at: newindexPath, animated: true, scrollPosition: .middle)
        }
    }
}
