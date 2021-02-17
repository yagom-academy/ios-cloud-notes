import UIKit

class MemoListTableViewController: UITableViewController {
    var memoList = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        decodeJSONToMemoList(fileName: "sample")
        
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

// MARK: JSONDecoding
extension MemoListTableViewController {
    func decodeJSONToMemoList(fileName: String) {
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: fileName) else {
            return
        }
        let jsonDecoder: JSONDecoder = JSONDecoder()
        do {
            let decodeData = try jsonDecoder.decode([Memo].self, from: dataAsset.data)
            memoList = decodeData
        } catch {
            showAlertMessage(MemoAppError.system.message)
        }
    }
}

// MARK: Alert
extension MemoListTableViewController {
    func showAlertMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
