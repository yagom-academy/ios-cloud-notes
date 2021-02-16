import UIKit

class MemoListTableViewController: UITableViewController {
    var memoList = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        let data = NSDataAsset(name: "sample")
        memoList = try! JSONDecoder().decode([Memo].self, from: data!.data)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.setLabels(memo: memoList[indexPath.row])
        
        return cell
    }
}
