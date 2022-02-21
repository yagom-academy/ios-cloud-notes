import UIKit
import SwiftyDropbox
import CoreData

class NoteListViewController: UITableViewController {
    private var noteListData = [Content]() {
        willSet {
            print(newValue)
        }
    }
    private weak var dataSourceDelegate: NoteListViewDelegate?
    private let firstIndex = IndexPath(row: 0, section: 0)
    lazy var selectedIndexPath: IndexPath? = self.firstIndex {
        didSet {
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
        }
    }

    // MARK: - View Component

    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "plus")
        button.target = self
        button.action = #selector(touchUpPlusButton)
        return button
    }()

    private lazy var configureButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "square.and.arrow.up")
        button.target = self
        button.action = #selector(showActionSheet)
        return button
    }()

    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if DropboxClientsManager.authorizedClient == nil {
            let loginAction = UIAlertAction(title: "로그인", style: .default) { _ in
                let scopeRequest = ScopeRequest(
                    scopeType: .user,
                    scopes: ["account_info.read", "files.content.write", "files.content.read"],
                    includeGrantedScopes: false
                )
                DropboxClientsManager.authorizeFromControllerV2(
                    UIApplication.shared,
                    controller: self,
                    loadingStatusDelegate: nil,
                    openURL: { (url: URL) -> Void in
                        UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                    scopeRequest: scopeRequest
                )
            }
            actionSheet.addAction(loginAction)
        } else {
            let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
                DropboxClientsManager.unlinkClients()
            }
            let downloadAction = UIAlertAction(title: "다운로드", style: .default) { _ in
                //self.download()
            }
            let uploadAction = UIAlertAction(title: "업로드", style: .default) { _ in
                //self.upload()
            }
            actionSheet.addAction(logoutAction)
            actionSheet.addAction(uploadAction)
            actionSheet.addAction(downloadAction)
        }

        actionSheet.popoverPresentationController?.barButtonItem = configureButton
        self.present(actionSheet, animated: true, completion: nil)
    }
    

    private lazy var activityController: UIActivityViewController = {
        let controller = UIActivityViewController(
            activityItems: ["memo"],
            applicationActivities: nil
        )
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: String(describing: NoteListCell.self)
        )
        configureNavigationBar()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.selectRow(
            at: self.selectedIndexPath,
            animated: false,
            scrollPosition: .none
        )
    }

    // MARK: - Override Method

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.selectRow(
            at: self.selectedIndexPath,
            animated: false,
            scrollPosition: .none
        )
    }

    // MARK: - Action Method

    @objc func touchUpPlusButton() {
        self.dataSourceDelegate?.creatNote()
    }

    // MARK: - Set Delegate Method

    func setDelegate(delegate: NoteListViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    // MARK: - Present Method

    func showActivityController() {
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
    }

    func showDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "메모를 삭제하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            let note = self.noteListData[indexPath.row]
            self.dataSourceDelegate?.deleteNote(note, index: indexPath.row)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Manipulate DataSource

    func setNoteList(_ data: [Content]) {
        self.noteListData = data
        tableView.reloadData()
    }

    func insert(_ note: Content) {
        self.noteListData.insert(note, at: 0)
        switch self.noteListData.count {
        case 1:
            self.tableView.reloadData()
        default:
            self.tableView.insertRows(at: [firstIndex], with: .automatic)
        }
    }

    func delete(at index: Int) {
        self.noteListData.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }

    // MARK: - Configure Views

    private func configureNavigationBar() {
        self.title = "메모"

        //self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItems = [addButton, configureButton, ]
    }

    private func configureTableView() {
        self.tableView.allowsSelectionDuringEditing = true
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListData.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteListCell.self),
            for: indexPath
        ) as? NoteListCell else {
            return UITableViewCell()
        }

        cell.configureContent(for: noteListData[indexPath.row])

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        dataSourceDelegate?.passNote(at: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = nil
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(
            style: .normal,
            title: "공유"
        ) { action, view, completionHandler in
            self.showActivityController()
            completionHandler(true)
        }

        let delete = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { action, view, completionHandler in
            self.showDeleteAlert(indexPath: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [share, delete])
    }
}
