import UIKit

class MemoListTableViewController: UITableViewController {
    var memoList = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        let data = NSDataAsset(name: "sample")
        memoList = try! JSONDecoder().decode([Memo].self, from: data!.data)
        
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationItem.title = "메모"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.receiveLabelsText(memo: memoList[indexPath.row])
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoContentsViewController = MemoContentsViewController()
        navigationController?.pushViewController(memoContentsViewController, animated: true)
        
        memoContentsViewController.receiveText(memo: memoList[indexPath.row])
    }
}
