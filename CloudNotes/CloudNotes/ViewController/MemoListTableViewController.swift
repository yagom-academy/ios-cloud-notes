import UIKit
import CoreData.NSManagedObject
import SwiftyDropbox

protocol TableViewListManagable: class {
    func updateTableViewList()
    func deleteCell(at indexPathRow: Int) throws
    func moveCellToTop()
    func changeEnrollButtonStatus(textViewIsEmpty: Bool)
}

class MemoListTableViewController: UITableViewController {
    var searchList = [NSManagedObject]()
    let searchController = UISearchController()
    lazy var enrollButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createMemo))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        configureNavigationBar()
//        showLoginDropboxAlert()
        DropboxManager.delegate = self
        DropboxManager.authorizeDropbox(viewController: self)
        DropboxManager.download()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deleteEmptyMemo()
    }
    
    private func configureNavigationBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = enrollButton
        navigationItem.searchController = searchController
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchController.searchBar.text == "" {
        case true:
            return CoreDataSingleton.shared.memoData.count
        case false:
            return searchList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        switch searchController.searchBar.text == "" {
        case true:
            let memo = CoreDataSingleton.shared.memoData[indexPath.row]
            cell.receiveLabelsText(memo: memo)
        case false:
            let memo = searchList[indexPath.row]
            cell.receiveLabelsText(memo: memo)
        }

        return cell
    }
    
    @objc func createMemo(sender: UIButton) {
        do {
            try CoreDataSingleton.shared.save(content: "")
            showContentsViewController(index: 0)
            tableView.reloadData()
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
            sender.isEnabled = false
            DropboxManager.upload()
        } catch {
            print(MemoAppSystemError.saveFailed.message)
        }
    }
    
    private func showContentsViewController(index: Int) {
        let memoContentsViewController = MemoContentsViewController()
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
        memoContentsViewController.delegate = self
        
        switch searchController.isActive {
        case true:
            memoContentsViewController.receiveText(memo: searchList[index])
        case false:
            memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[index])
        }
        
        self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)
    }
    
    private func deleteEmptyMemo() -> Bool {
        guard let firstMemo = CoreDataSingleton.shared.memoData.first else {
            return false
        }
        let firstIndexPath = IndexPath(row: 0, section: 0)
        
        if firstMemo.value(forKey: "content") as? String == "" {
            do  {
                try CoreDataSingleton.shared.delete(object: firstMemo)
                CoreDataSingleton.shared.memoData.remove(at: 0)
                tableView.deleteRows(at: [firstIndexPath], with: .fade)
                enrollButton.isEnabled = true
                return true
            } catch {
                print(MemoAppSystemError.deleteFailed.message)
                return false
            }
        }
        
        return false
    }
}

// MARK: UITableViewDelegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathRow = indexPath.row
        
        if indexPath.row != 0 {
            if deleteEmptyMemo() {
                indexPathRow = indexPath.row - 1
            }
        }
        
        showContentsViewController(index: indexPathRow)
        UserDefaults.standard.set(indexPathRow, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let memoContentsView = MemoContentsViewController()
        do {
            try deleteCell(at: indexPath.row)
            
            if splitViewController?.traitCollection.horizontalSizeClass == .regular {
                switch CoreDataSingleton.shared.memoData.isEmpty {
                case false:
                    memoContentsView.receiveText(memo: CoreDataSingleton.shared.memoData[0])
                    self.splitViewController?.showDetailViewController(memoContentsView, sender: nil)
                case true:
                    splitViewController?.viewControllers.removeLast()
                }
            }
        } catch {
            print(MemoAppSystemError.deleteFailed.message)
        }
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
    
    private func showLoginDropboxAlert() {
        let alert = UIAlertController(title: nil, message: "Dropbox와 동기화하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            DropboxManager.authorizeDropbox(viewController: self)
            DropboxManager.download()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: TableViewListManagable
extension MemoListTableViewController: TableViewListManagable {
    func updateTableViewList() {
        tableView.reloadData()
    }
    
    func deleteCell(at indexPathRow: Int) throws {
        let indexPathRowToDelete: Int
        
        switch searchController.searchBar.text == "" {
        case true:
            indexPathRowToDelete = indexPathRow
        case false:
            indexPathRowToDelete = try findSameMemoIndexInCoreData(currentIndex: indexPathRow)
        }
        
        try CoreDataSingleton.shared.delete(object: CoreDataSingleton.shared.memoData[indexPathRowToDelete])
        CoreDataSingleton.shared.memoData.remove(at: indexPathRowToDelete)
        
        searchList.remove(at: indexPathRow)
        tableView.reloadData()
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
    }
    
    func moveCellToTop() {
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue) as? Int == 0 {
            return
        }
        
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        let firstIndexPath = IndexPath(item: 0, section: 0)
        
        let memo = CoreDataSingleton.shared.memoData.remove(at: selectedMemoIndexPathRow)
        CoreDataSingleton.shared.memoData.insert(memo, at: 0)
        
        self.tableView.moveRow(at: indexPath, to: firstIndexPath)
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
    }
    
    func changeEnrollButtonStatus(textViewIsEmpty: Bool) {
        enrollButton.isEnabled = !textViewIsEmpty
    }
    
    private func findSameMemoIndexInCoreData(currentIndex: Int) throws -> Int {
        if CoreDataSingleton.shared.memoData.count > 0 {
            for i in 0...CoreDataSingleton.shared.memoData.count {
                if searchList[currentIndex] == CoreDataSingleton.shared.memoData[i] {
                    return i
                }
            }
        }
        
        throw MemoAppSystemError.unkowned
    }
}

extension MemoListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let totalMemoList = CoreDataSingleton.shared.memoData
        searchList = totalMemoList.filter({ memo -> Bool in
            guard let memoText = (memo.value(forKey: "content") as? String) else {
                return false
            }
            return memoText.contains(searchText)
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        tableView.reloadData()
    }
}

extension MemoListTableViewController: DropboxDownloadDelegate {
    func fetchTableViewList() {
        CoreDataSingleton.shared.fetch()
        self.tableView.reloadData()
    }
}
