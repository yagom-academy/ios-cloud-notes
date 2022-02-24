import UIKit
import SwiftyDropbox

    // MARK: - Declare NoteListViewController Delegate
protocol NoteListViewControllerDelegate: AnyObject {
    func noteListViewController(
        _ viewController: NoteListViewController,
        didSelectedCell indexPath: IndexPath
    )
    
    func noteListViewController(addButtonTapped viewController: NoteListViewController)
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToDelete indexPath: IndexPath
    )
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToShare indexPath: IndexPath
    )
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToUpload indexPath: IndexPath
    )
}
    // MARK: - Declare NoteListViewController Datasource
protocol NoteListViewControllerDataSource: AnyObject {
    func noteListViewControllerNumberOfData(
        _ viewController: NoteListViewController
    ) -> Int
    func noteListViewControllerSampleForCell(
        _ viewController: NoteListViewController,
        indexPath: IndexPath
    ) -> MemoType?
}

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
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        setUpLayout()
        setUpNavigationItems()
        presentDropboxLoginScene()
    }
    // MARK: - Method
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            listTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func setUpNavigationItems() {
        navigationItem.title = "메모"
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tappedPlusButton)
        )
        navigationItem.rightBarButtonItems = [addButton]
    }

    @objc private func tappedPlusButton() {
        delegate?.noteListViewController(addButtonTapped: self)
    }
    
    func updateTableView() {
        listTableView.reloadData()
    }
    
    func extractSeletedRow() -> IndexPath? {
        listTableView.indexPathForSelectedRow
    }
    
    func reloadRow(at indexPath: IndexPath) {
        listTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func presentVerifyingDeletionAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "삭제하시겠습니까?", message: "후회하지 않으시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self]_ in
            self?.listTableView.reloadRows(at: [indexPath], with: .right)
        }
        let ok = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToDelete: indexPath)
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentDropboxLoginScene() {
        // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )

        // Note: this is the DEPRECATED authorization flow that grants a long-lived token.
        // If you are still using this, please update your app to use the `authorizeFromControllerV2` call instead.
        // See https://dropbox.tech/developers/migrating-app-permissions-and-access-tokens
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                      })
    }
}
// MARK: - UITableView Delegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.noteListViewController(self, didSelectedCell: indexPath)
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
                self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToShare: indexPath)
            }
        uploadAction.backgroundColor = .systemBlue
        return  UISwipeActionsConfiguration(actions: [uploadAction])
    }
}
// MARK: - UITableView DataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.noteListViewControllerNumberOfData(self) ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: NoteListTableViewCell.self,
            for: indexPath)
        
        guard let data = dataSource?.noteListViewControllerSampleForCell(
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
