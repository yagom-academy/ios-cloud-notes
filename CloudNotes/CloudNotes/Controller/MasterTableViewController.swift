import UIKit

protocol MemoSelectionDelegate: AnyObject {
    var memoSelectionDestination: UIViewController { get }
    func applyData(with data: Memo)
}

final class MasterTableViewController: UITableViewController {
    // MARK: - Properties
    var memoDataSource: MasterTableViewDataSourceProtocol?
    weak var delegate: MemoSelectionDelegate?
    
    // MARK: - Initializer
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience init(style: UITableView.Style, dataSource: MasterTableViewDataSourceProtocol = MasterTableViewDataSource(), delegate: MemoSelectionDelegate) {
        self.init(style: style)
        self.memoDataSource = dataSource
        self.delegate = delegate
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstCell()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        let addMemoButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(touchUpAddMemoButton))
        navigationItem.rightBarButtonItem = addMemoButton
    }
    
    @objc func touchUpAddMemoButton() {
        let currentTime = NSDate().timeIntervalSince1970
        let memo = TemporaryMemo(title: "새로운 메모", body: "테스트용 메모입니다.", lastModifiedDate: currentTime, memoId: UUID()) // Test
        let request = Memo.fetchRequest()
        let firstIndexPath = IndexPath(row: 0, section: 0)
        
        CoreDataManager.shared.saveContext(memo: memo)
        memoDataSource?.memos = CoreDataManager.shared.fetch(request)
        // tableView.reloadData()  // selectFirstCell 비정상작동
        tableView.insertRows(at: [firstIndexPath], with: .none)
        tableView(tableView, didSelectRowAt: firstIndexPath)
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .middle)
    }
    
    private func configureTableView() {
        tableView.dataSource = memoDataSource as? UITableViewDataSource
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: MasterTableViewCell.reuseIdentifier)
    }
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("didChangeTextView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTableViewCell), name: Notification.Name("didDeleteMemo"), object: nil)
    }
    
    @objc func updateTableView() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        guard let previousIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let memoToMove = memoDataSource?.memos?.remove(at: previousIndexPath.row) else {
            return
        }
        memoDataSource?.memos?.insert(memoToMove, at: firstIndexPath.row)
        
        tableView.moveRow(at: previousIndexPath, to: firstIndexPath)
        tableView.reloadRows(at: [firstIndexPath], with: .automatic)
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
    }
    
    @objc func deleteTableViewCell() {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        deleteMemo(at: currentIndexPath)
    }
    
    private func deleteMemo(at index: IndexPath) {
        let removedMemo = memoDataSource?.memos?.remove(at: index.row)
        CoreDataManager.shared.deleteMemo(memoId: removedMemo?.memoId)
        tableView.deleteRows(at: [index], with: .fade)
        selectFirstCell()
    }
    
    private func selectFirstCell() {
        if memoDataSource?.memos?.isEmpty == false {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .middle)
            tableView(tableView, didSelectRowAt: firstIndexPath)
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memos = memoDataSource?.memos else {
            return
        }
        
        guard let destination = delegate?.memoSelectionDestination as? DetailViewController else {
            return
        }

        destination.applyData(with: memos[indexPath.row])
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
            guard let memos = self.memoDataSource?.memos else {
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
