import UIKit
import CoreData
import SwiftyDropbox

final class NoteTableViewController: UITableViewController {
    
    enum Section {
        
        case main
        
    }
    
    private let viewModel: NoteViewModel
    weak var delegate: NoteTableViewDelegate?
    private lazy var dataSource = {
        return NoteTableViewDiffableDataSource(
            tableView: self.tableView) { tableView, _, item in
                let identifier = NoteTableViewCell.reuseIdentifier
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoteTableViewCell else {
                    return nil
                }
                
                cell.setLabelText(
                    title: item.title == "" ? "새로운 메모" : item.title,
                    body: item.body,
                    lastModified: self.viewModel.fetchDate(note: item))
                
                cell.backgroundColor = .tertiarySystemBackground
                return cell
            }
    }()
    
    private lazy var addNoteBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteDidTap))
    }()
    
    private lazy var loginBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "externaldrive.badge.icloud"),
            style: .plain,
            target: self,
            action: #selector(loginButtonDidTap))
    }()
    
    private lazy var noteSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLayout()
        viewModel.updateUIHandler = updateUI
        viewModel.updateUIByDataHandler = updateTable
        viewModel.viewDidLoad()
        updateUI()
        
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    init(viewModel: NoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.noteData, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateTable(_ type: NSFetchedResultsChangeType) {
        let snapshot = dataSource.snapshot()
        guard let item = snapshot.itemIdentifiers.first else {
            delegate?.selectNote(with: nil)
            return
        }
        
        switch type {
        case .move:
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        case .update:
            return
        default:
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
            delegate?.selectNote(with: item.identifier)
        }
    }
    
    private func configureTableView() {
        tableView.register(NoteTableViewCell.self)
    }
    
    private func configureLayout() {
        navigationController?.navigationBar.topItem?.title = "메모"
        navigationItem.rightBarButtonItems = [addNoteBarButtonItem, loginBarButtonItem]
        navigationItem.searchController = noteSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc
    private func addNoteDidTap(_ sender: UIBarButtonItem) {
        viewModel.createNote()
    }
    
    private func loginDropBox() {
        let scopeRequest = ScopeRequest(
            scopeType: .user,
            scopes: ["account_info.read", "files.content.write", "files.content.read"],
            includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    @objc
    private func loginButtonDidTap(_ sender: UIBarButtonItem) {
        let backupAction = UIAlertAction(title: "Backup", style: .default) { [self] _ in
            viewModel.uploadDB()
        }
        let restoreAction = UIAlertAction(title: "Restore", style: .default) { [self] _ in
            viewModel.downloadDB()
        }
        var actionList = [backupAction, restoreAction]
        
        if DropboxClientsManager.authorizedClient != nil {
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                DropboxClientsManager.unlinkClients()
            }
            actionList.insert(logoutAction, at: 0)
        } else {
            let loginAction = UIAlertAction(title: "Login", style: .default) { [self] _ in
                loginDropBox()
            }
            actionList = [loginAction]
        }
        
        presentAlert(preferredStyle: .actionSheet) { alertController in
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.barButtonItem = sender
            alertController.addAction(actionList)
        }
    }
    
}

extension NoteTableViewController {
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectNote(with: nil)
        let item = dataSource.itemIdentifier(for: indexPath)
        guard let identifier = item?.identifier else {
            return
        }
        delegate?.selectNote(with: identifier)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let snapshot = self.dataSource.snapshot()
        let item = snapshot.itemIdentifiers[indexPath.row]
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.presentActivityView(items: ["\(item.title)\n\(item.body)"]) { controller in
                let cell = tableView.cellForRow(at: indexPath)
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.sourceView = cell
            }
        }
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.presentAlert(title: "진짜요?", message: "정말로 지워요?") { controller in
                let actions = [
                    UIAlertAction(title: "취소", style: .cancel),
                    UIAlertAction(title: "삭제", style: .destructive) { _ in
                        self.viewModel.deleteNote(identifier: item.identifier)
                    }]
                controller.addAction(actions)
            }
        }
        
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let actionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return actionsConfiguration
    }
    
    private func performQuery(with text: String) {
        let datas = viewModel.noteData.filter { note in
            return note.title.contains(text) || note.body.contains(text)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(datas, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension NoteTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
    
}

extension NoteTableViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.updateUI()
    }
    
}
