import UIKit
import SwiftyDropbox

protocol MemoSelectionDelegate: AnyObject {
    var memoSelectionDestination: UIViewController { get }
    func applyData(with data: MemoEntity)
    func clearTextView()
}

final class MasterTableViewController: UITableViewController {
    // MARK: - Properties
    private var memoDataSource: MasterTableViewDataSourceProtocol?
    weak var delegate: MemoSelectionDelegate?
    private let dropBoxClient = DropboxClientsManager.authorizedClient
    
    // MARK: - Initializer
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    // 오류 발생 ('let' property 'memoDataSource' may not be initialized directly; use "self.init(...)" or "self = ..." instead)
//    init(style: UITableView.Style, memoDataSource: MasterTableViewDataSourceProtocol = MasterTableViewDataSource(), delegate: MemoSelectionDelegate) {
//        self.init(style: style)
//        self.memoDataSource = memoDataSource
//        self.delegate = delegate
//    }
    
    // 기존 코드
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
        
        presentSafariViewController()
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
    }
    
    @objc private func touchUpAddMemoButton() {
        let currentTime = NSDate().timeIntervalSince1970
        let memo = TemporaryMemo(title: "새로운 메모", body: "테스트용 메모입니다.", lastModifiedDate: currentTime, memoId: UUID()) // Test
        let firstIndexPath = IndexPath(row: 0, section: 0)
        
        memoDataSource?.saveMemo(memo)
        memoDataSource?.fetchMemos()
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

extension MasterTableViewController {
    func presentSafariViewController() {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.write", "account_info.read", "files.metadata.write" ,"files.metadata.read", "files.content.write", "files.content.read", "file_requests.write"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func createFolderAtDropBox() {
        dropBoxClient?.files.createFolderV2(path: "/test/path/in/Dropbox/account").response { response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func uploadToDropBox() {
        let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!

        let request = dropBoxClient?.files.upload(path: "/test/path/in/Dropbox/account", mode: .overwrite, autorename: true, clientModified: Date(), mute: false, propertyGroups: nil, strictConflict: false, input: fileData)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
            }
    }
    
    func downloadFromDropBox() {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent("myTestFile")
        let destination: (URL, HTTPURLResponse) -> URL = { _, response in
            return destURL
        }
        dropBoxClient?.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
            }
    }
}
