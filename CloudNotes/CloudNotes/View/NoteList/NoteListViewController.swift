import UIKit
import SwiftyDropbox

class NoteListViewController: UIViewController {
    // MARK: - Property
    weak var delegate: NoteListViewControllerDelegate?
    weak var dataSource: NoteListViewControllerDataSource?
    private var listTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(cellWithClass: NoteListTableViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    // MARK: - ViewLifeCycle
    override func loadView() {
        view = .init()
        view.backgroundColor = .white
        view.addSubview(listTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureListTableView()
        self.configureLayout()
        self.setUpNavigationItems()
        self.presentDropboxLoginScene()
    }
    // MARK: - Method
    private func configureListTableView() {
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        self.listTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    private func configureLayout() {
        NSLayoutConstraint.activate([
            self.listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.listTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            self.listTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func setUpNavigationItems() {
        self.navigationItem.title = "메모"
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tappedPlusButton)
        )
        self.navigationItem.rightBarButtonItems = [addButton]
    }

    @objc private func tappedPlusButton() {
        self.delegate?.noteListViewController(addButtonTapped: self)
    }
    
    func updateTableView() {
        self.listTableView.reloadData()
    }
    
    func extractSeletedRow() -> IndexPath? {
        self.listTableView.indexPathForSelectedRow
    }
    
    func reloadRow(at indexPath: IndexPath) {
        self.listTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func presentVerifyingDeletionAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "삭제하시겠습니까?",
            message: "후회하지 않으시겠습니까?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self]_ in
            self?.listTableView.reloadRows(at: [indexPath], with: .right)
        }
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToDelete: indexPath)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentDropboxLoginScene() {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [
            "account_info.read",
            "files.content.write",
            "files.content.read",
            "file_requests.write",
            "file_requests.read"],
        includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
}
// MARK: - UITableView Delegate
extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.noteListViewController(self, didSelectedCell: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(
            style: .normal,
            title: nil) { [weak self] _, _, _ in
                self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToShare: indexPath)
            }
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] _, _, _ in
                self?.presentVerifyingDeletionAlert(indexPath: indexPath)
            })
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let actionConfigurations = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return actionConfigurations
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uploadAction = UIContextualAction(
            style: .normal,
            title: "Dropbox") { [weak self] _, _, _ in
                self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToUpload: indexPath)
            }
        uploadAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [uploadAction])
    }
}
// MARK: - UITableView DataSource
extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource?.noteListViewControllerNumberOfData(self) ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: NoteListTableViewCell.self,
            for: indexPath)
        
        guard let data = self.dataSource?.noteListViewControllerSampleForCell(
            self,
            indexPath: indexPath
        ) else {
            return UITableViewCell()
        }
        
        guard let title = data.title, let preview = data.body, let lastModified = data.lastModified else {
            return UITableViewCell()
        }
        
        cell.updateLabel(title: title, lastModified: lastModified, preview: preview)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
