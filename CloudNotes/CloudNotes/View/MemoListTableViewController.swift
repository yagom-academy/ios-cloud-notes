import UIKit

class MemoListTableViewController: UITableViewController {
    private let enrollButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIsCellSelected), name: NSNotification.Name(NotificationName.showTableView.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell), name: NSNotification.Name(rawValue: NotificationName.deleteCell.rawValue), object: nil)
    }
    
    @objc func changeIsCellSelected() {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        tableView.reloadData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enrollButton)
        enrollButton.setImage(UIImage(systemName: "plus"), for: .normal)
        enrollButton.addTarget(self, action: #selector(createMemo), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataSingleton.shared.memoData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        let record = CoreDataSingleton.shared.memoData[indexPath.row]
        
        cell.listTitleLabel.text = record.value(forKey: "title") as? String
        cell.listShortBodyLabel.text = record.value(forKey: "body") as? String
//        cell.listLastModifiedDateLabel.text = record.value(forKey: "lastModified") as? Date
        
        return cell
    }
    
    @objc func createMemo(sender: UIButton) {
        CoreDataSingleton.shared.save(title: "lll", body: "ooo")
        
        let memoContentsViewController = MemoContentsViewController()
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[0])
        tableView.reloadData()
        self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)
        
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
    }
    
    @objc func deleteCell() {
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: UITableViewDelegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoContentsViewController = MemoContentsViewController()
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
        
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        UserDefaults.standard.set(indexPath.row, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        
        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[indexPath.row])
        self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)
    }
}

// MARK: Alert
extension MemoListTableViewController {
    private func showAlertMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
