import UIKit

class MemoListViewController: UITableViewController {
    enum Constant {
        static let navigationTitle = "메모"
        static let lastModified = "lastModified"
    }
    
    private var memoListInfo = [MemoListInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpNavigationItem()
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    func setUpData(data: [MemoListInfo]) {
        memoListInfo = data
    }
    
    func updateData(at index: Int, with data: MemoListInfo) {
        memoListInfo[index] = data
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
        let newMemo = [Constant.lastModified: Date().timeIntervalSince1970]
        MemoDataManager.shared.insert(items: newMemo)
        guard let splitVC = self.splitViewController as? SplitViewController,
              let newData = MemoDataManager.shared.fetch() else {
            return
        }
        splitVC.updateData(newData)
    }
}

// MARK: - DataSource
extension MemoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoListInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MemoListCell.identifier,
            for: indexPath
        ) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.configure(with: memoListInfo[indexPath.row])
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
