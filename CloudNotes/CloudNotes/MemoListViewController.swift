import UIKit

class MemoListViewController: UITableViewController {

    private var memoListInfo = [MemoListInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpNavigationItem()
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    func setUpData(data: [MemoListInfo]) {
        memoListInfo = data
    }
}

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

extension MemoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        splitVC.present(at: indexPath.row)
    }
}
