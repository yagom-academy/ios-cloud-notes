import UIKit
import SwiftyDropbox
import CoreData

class NoteListViewController: UITableViewController {

    // MARK: - Properties

    var selectedIndexPath: IndexPath? {
        didSet {
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
        }
    }
    private let firstIndex = IndexPath(row: 0, section: 0)
    private var noteListData = [Content]()
    private weak var dataSourceDelegate: NoteListViewDelegate?

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

    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchBar.placeholder = "검색"

        return controller
    }()

    @objc
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if DropboxClientsManager.authorizedClient == nil {
            self.setActionWithLogoutStatus(in: actionSheet)
        } else {
            self.setActionWithLoginStatus(in: actionSheet)
        }

        actionSheet.popoverPresentationController?.barButtonItem = self.configureButton
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func setActionWithLoginStatus(in actionSheet: UIAlertController) {
        let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            DropboxClientsManager.unlinkClients()
        }
        let downloadAction = UIAlertAction(title: "다운로드", style: .default) { _ in
            self.dataSourceDelegate?.download()
        }
        let uploadAction = UIAlertAction(title: "업로드", style: .default) { _ in
            self.dataSourceDelegate?.upload()
        }

        actionSheet.addAction(logoutAction)
        actionSheet.addAction(uploadAction)
        actionSheet.addAction(downloadAction)

        actionSheet.title = dataSourceDelegate?.synchronizationLastUpdated()
    }

    private func setActionWithLogoutStatus(in actionSheet: UIAlertController) {
        let loginAction = UIAlertAction(title: "로그인", style: .default) { _ in
            self.dataSourceDelegate?.logIn()
        }

        actionSheet.addAction(loginAction)
    }

    private lazy var activityController: UIActivityViewController = {
        let controller = UIActivityViewController(
            activityItems: ["memo"],
            applicationActivities: nil
        )

        return controller
    }()

// MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpController()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setInitialSelectedCell()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.selectRow(
            at: self.selectedIndexPath,
            animated: false,
            scrollPosition: .none
        )
    }

    func presentUploadFailureAlert() {
        let uploadFailureAlert = UIAlertController(
            title: "백업에 실패하였습니다",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        uploadFailureAlert.addAction(okAction)

        if !uploadFailureAlert.isBeingPresented {
            self.present(uploadFailureAlert, animated: true, completion: nil)
        }
    }

    func presentDownloadFailureAlert() {
        let downloadFailureAlert = UIAlertController(
            title: "다운로드에 실패하였습니다",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        downloadFailureAlert.addAction(okAction)

        if !downloadFailureAlert.isBeingPresented {
            self.present(downloadFailureAlert, animated: true, completion: nil)
        }
    }

    func setDelegate(delegate: NoteListViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    func setNoteList(_ data: [Content]) {
        self.noteListData = data
        self.tableView.reloadData()
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

    private func setUpController() {
        self.setUpSearchController()

        self.tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: String(describing: NoteListCell.self)
        )

        self.configureNavigationBar()
        self.configureTableView()
        self.setSearchResultTableViewDelegate()

        self.selectedIndexPath = IndexPath(row: 0, section: 0)
    }

    private func setUpSearchController() {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.searchController.searchResultsUpdater = self
    }

    private func setInitialSelectedCell() {
        self.tableView.selectRow(
            at: self.selectedIndexPath,
            animated: false,
            scrollPosition: .none
        )
    }

    @objc
    private func touchUpPlusButton() {
        self.dataSourceDelegate?.creatNote()
    }

    private func showActivityController() {
        self.activityController.popoverPresentationController?.sourceView = self.view
        self.present(self.activityController, animated: true, completion: nil)
    }

    private func showDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "메모를 삭제하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let note = self.noteListData[indexPath.row]
            self.dataSourceDelegate?.deleteNote(note, index: indexPath.row)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func configureNavigationBar() {
        self.title = "메모"
        self.navigationItem.rightBarButtonItems = [addButton, configureButton]
    }

    private func configureTableView() {
        self.tableView.allowsSelectionDuringEditing = true
    }

    private func setSearchResultTableViewDelegate() {
        guard let tableViewController = self.searchController.searchResultsController
                as? SearchResultViewController
        else {
            return
        }

        tableViewController.tableView.delegate = self
    }
}

// MARK: - Table View Data Source and Delegate

extension NoteListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListData.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NoteListCell.self)
        cell.configureContent(for: noteListData[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            self.passNoteByMainTableView(at: indexPath)
        } else {
            self.passNoteBySearchResultTableView(at: indexPath)
        }

        self.splitViewController?.show(.secondary)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = nil
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "공유") { _, _, completionHandler in
            self.showActivityController()
            completionHandler(true)
        }

        let delete = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { _, _, completionHandler in
            self.showDeleteAlert(indexPath: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [share, delete])
    }

    private func passNoteByMainTableView(at indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.dataSourceDelegate?.passNote(at: indexPath.row)
    }

    private func passNoteBySearchResultTableView(at indexPath: IndexPath) {
        guard let controller = self.searchController.searchResultsController
                as? SearchResultViewController
        else {
            return
        }

        let selectedNote = controller.selectedSearchedNote(at: indexPath)

        for (index, note) in noteListData.enumerated()
        where note.identification == selectedNote.identification {
            self.selectedIndexPath = IndexPath(row: index, section: 0)
            self.dataSourceDelegate?.passNote(at: index)

            return
        }
    }
}

// MARK: - UISearchController Result Updater

extension NoteListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let controller = self.searchController.searchResultsController
                as? SearchResultViewController,
              let searchBarText = self.searchController.searchBar.text?.lowercased()
        else {
            return
        }

        let searchedNoteData = self.noteListData.filter { note in
            (note.title + note.body).lowercased().contains(searchBarText)
        }

        controller.setSearchedNoteData(searchedNoteData)
    }
}
