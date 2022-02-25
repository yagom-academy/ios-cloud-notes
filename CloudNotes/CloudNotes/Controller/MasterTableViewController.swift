import UIKit

protocol MemoSelectionDelegate: AnyObject {
    var memoSelectionDestination: UIViewController { get }
    func applyData(with data: MemoEntity)
    func clearTextView()
}

final class MasterTableViewController: UITableViewController {
    // MARK: - Properties
    private(set) var memoDataSource: MasterTableViewDataSourceProtocol?
    weak var delegate: MemoSelectionDelegate?
    lazy var searchResultViewController = SearchResultTableViewController(style: .insetGrouped, memos: memoDataSource?.retrieveMemos(), delegate: delegate)
    
    // MARK: - Initializer
    init(style: UITableView.Style = .insetGrouped, dataSource: MasterTableViewDataSourceProtocol = MasterTableViewDataSource(), delegate: MemoSelectionDelegate) {
        self.memoDataSource = dataSource
        self.delegate = delegate
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureNotificationCenter()
        tableView.reloadData()
        
        DropBoxManager().createFolderAtDropBox() // 앱 최초실행 시 폴더를 한 번 생성함 (그 후에는 error를 출력)
        DropBoxManager().presentSafariViewController(controller: self) // DropBox 관련 기능
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeMemoIfNotEmpty()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        let addMemoButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(touchUpAddMemoButton))
        navigationItem.rightBarButtonItem = addMemoButton
        
        configureSearchController()
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    @objc private func touchUpAddMemoButton() {
        let currentTime = NSDate().timeIntervalSince1970
        let memo = TemporaryMemo(title: "새로운 메모", body: "내용을 입력해주세요.", lastModifiedDate: currentTime, memoId: UUID()) // Test
        let firstIndexPath = IndexPath(row: 0, section: 0)
        
        memoDataSource?.saveMemo(memo)
        memoDataSource?.fetchMemos()
        // tableView.reloadData()  // selectFirstCell 비정상작동
        tableView.insertRows(at: [firstIndexPath], with: .none)
        tableView(tableView, didSelectRowAt: firstIndexPath)
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .middle)
        
        DropBoxManager().uploadToDropBox()
    }
    
    private func configureTableView() {
        tableView.dataSource = memoDataSource as? UITableViewDataSource
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: MasterTableViewCell.reuseIdentifier)
    }
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("didChangeTextView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTableViewCell), name: Notification.Name("didDeleteMemo"), object: nil)
    }
    
    @objc private func updateTableView(_ notification: Notification) {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        guard let previousIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        memoDataSource?.removeMemo(at: previousIndexPath.row)

        guard let memoToUpdate = notification.userInfo?["memo"] as? MemoEntity else {
            return
        }
        memoDataSource?.insertMemo(memoToUpdate, at: firstIndexPath.row)
        memoDataSource?.updateMemo(memoToUpdate)
        
        tableView.moveRow(at: previousIndexPath, to: firstIndexPath)
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .middle)
        
        updateCell(at: firstIndexPath, with: memoToUpdate)
    }
    
    private func updateCell(at indexPath: IndexPath, with memo: MemoEntity) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MasterTableViewCell else {
            return
        }
        
        cell.applyData(memo)
    }
    
    @objc private func deleteTableViewCell() {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        deleteMemo(at: currentIndexPath)
    }
    
    private func deleteMemo(at index: IndexPath) {
        let removedMemo = memoDataSource?.removeMemo(at: index.row)
        memoDataSource?.deleteMemo(with: removedMemo?.memoId)
        tableView.deleteRows(at: [index], with: .fade)
        changeMemoIfNotEmpty()
        
        DropBoxManager().uploadToDropBox()
    }
    
    private func changeMemoIfNotEmpty() {
        if memoDataSource?.retrieveMemos()?.isEmpty == false {
            selectFirstMemo()
        } else {
            clearMemo()
        }
    }
    
    private func selectFirstMemo() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .middle)
        tableView(tableView, didSelectRowAt: firstIndexPath)
    }
    
    private func clearMemo() {
        guard let destination = delegate?.memoSelectionDestination as? DetailViewController else {
            return
        }
        destination.clearTextView()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memos = memoDataSource?.retrieveMemos() else {
            return
        }
        
        guard let destination = delegate?.memoSelectionDestination as? DetailViewController else {
            return
        }
        
        let memo = memos[indexPath.row]

        destination.applyData(with: memo)
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: destination), sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.deleteMemo(at: indexPath)
            }
            
            let alert = AlertFactory().createAlert(style: .alert, title: "진짜요?", message: "정말로 삭제하시겠어요?", actions: cancelAction, deleteAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            guard let memos = self.memoDataSource?.retrieveMemos() else {
                return
            }
            
            let title = memos[indexPath.row].title
            let textToShare: [Any] = [title ?? ""]
            let acitivityView = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    
            let alertPopover = acitivityView.popoverPresentationController
            alertPopover?.sourceView = tableView.cellForRow(at: indexPath)
            
            self.present(acitivityView, animated: true, completion: nil)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - SearchResult TableViewController delegate
extension MasterTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchResultViewController.searchMemo(with: text)
        searchResultViewController.tableView.reloadData()
    }
}
