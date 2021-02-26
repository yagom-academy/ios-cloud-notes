import UIKit

class MemoListTableViewController: UITableViewController {
    private let enrollButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        setUpNotification()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
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
        let memo = CoreDataSingleton.shared.memoData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.receiveLabelsText(memo: memo)
        return cell
    }

    @objc func createMemo(sender: UIButton) {
        if CoreDataSingleton.shared.save(title: "lll", body: "ooo") {
            let memoContentsViewController = MemoContentsViewController()
            let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
            memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[0])
            tableView.reloadData()
            self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)

            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        } else {
            showAlertMessage("메모 생성에 실패했습니다!")
        }
    }
}

// MARK: UITableViewDelegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.resignFirstResponder.rawValue), object: nil)
        
        let memoContentsViewController = MemoContentsViewController()
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
        
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        UserDefaults.standard.set(indexPath.row, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        
        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[indexPath.row])
        self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)
    }
}

// MARK: Notification
extension MemoListTableViewController {
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewList), name: NSNotification.Name(NotificationName.updateTableViewList.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell), name: NSNotification.Name(rawValue: NotificationName.deleteCell.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveCellToTop), name: NSNotification.Name(rawValue: NotificationName.moveCellToTop.rawValue), object: nil)
    }
    
    @objc func updateTableViewList() {
        tableView.reloadData()
    }
    
    @objc func deleteCell() {
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    @objc func moveCellToTop() {
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        let firstIndexPath = IndexPath(item: 0, section: 0)
        
        let memo = CoreDataSingleton.shared.memoData.remove(at: selectedMemoIndexPathRow)
        CoreDataSingleton.shared.memoData.insert(memo, at: 0)
        
        self.tableView.moveRow(at: indexPath, to: firstIndexPath)
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
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
