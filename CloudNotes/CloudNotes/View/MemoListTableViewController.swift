import UIKit

class MemoListTableViewController: UITableViewController {
    var memoList = [Memo]()
    let memoContentsView = MemoContentsViewController()
    let enrollButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        decodeJSONToMemoList(fileName: "sample")
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enrollButton)
        enrollButton.translatesAutoresizingMaskIntoConstraints = false
        enrollButton.setImage(UIImage(systemName: "plus"), for: .normal)
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
        
        let savedTraitCollection = UITraitCollection.current
        
        switch (savedTraitCollection.horizontalSizeClass) {
        case (.regular):
            memoContentsView.receiveText(memo: memoList[indexPath.row])
            
        case (.compact):
            memoContentsView.receiveText(memo: memoList[indexPath.row])
            self.navigationController?.pushViewController(memoContentsView, animated: true)
            
        default: break
        }
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
