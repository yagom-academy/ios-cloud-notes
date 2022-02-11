import UIKit

class MemoListViewController: UITableViewController {
    enum Constant {
        static let navigationTitle = "메모"
        static let lastModified = "lastModified"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpNavigationItem()
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    func updateData(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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
            "id": UUID()
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
        tableView.insertRows(at: [IndexPath(row: .zero, section: .zero)], with: .fade)
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
        cell.configure(with: MemoDataManager.shared.memoList[indexPath.row])
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
}
