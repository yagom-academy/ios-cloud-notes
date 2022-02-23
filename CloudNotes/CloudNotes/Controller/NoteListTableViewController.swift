import UIKit
import CoreData

final class NoteListTableViewController: UITableViewController {
    
    private var viewModel: NoteViewModel
    weak var delegate: NoteListTableViewDelegate?
    private lazy var dataSource = {
        return NoteListTableViewDiffableDataSource(
            model: viewModel,
            tableView: self.tableView) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.reuseIdentifier)
            
            if let cell = cell as? NoteListTableViewCell {
                cell.setLabelText(
                    title: item.title,
                    body: item.body,
                    lastModified: self.viewModel.fetchDate(note: item)
                )
            }
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLayout()
        viewModel.updatePrimaryHandler = updateUI
        viewModel.updateSecondaryHandler = updateTable
        viewModel.viewDidLoad()
        updateUI()
    }
    
    init(model: NoteViewModel) {
        self.viewModel = model
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
        tableView.register(NoteListTableViewCell.self)
    }
    
    private func configureLayout() {
        navigationController?.navigationBar.topItem?.title = "메모"
        let addBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteDidTap))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc
    private func addNoteDidTap(_ sender: UIBarButtonItem) {
        viewModel.createNote()
    }
    
}

extension NoteListTableViewController {
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectNote(with: nil)
        let item = dataSource.itemIdentifier(for: indexPath)
        guard let identifier = item?.identifier else {
            return
        }
        delegate?.selectNote(with: identifier)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, view, completionHandler) in
            
            self.presentActivityView(items: [""]) { activityViewController in
                activityViewController.modalPresentationStyle = .formSheet
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.popoverPresentationController?.sourceRect = view.bounds
                activityViewController.popoverPresentationController?.permittedArrowDirections = []
            }
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, completionHandler) in
            let item = self.dataSource.itemIdentifier(for: indexPath)
            guard let identifier = item?.identifier else {
                return
            }
            
            self.presentAlert(title: "진짜요?", message: "정말로 지워요?") { alert in
                let actions = [
                    UIAlertAction(title: "취소", style: .cancel),
                    UIAlertAction(title: "삭제", style: .destructive) { _ in
                        self.viewModel.deleteNote(identifier: identifier)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.selectRow(
                            at: indexPath,
                            animated: true,
                            scrollPosition: UITableView.ScrollPosition.top)
                        completionHandler(true)
                    }
                ]
                alert.addAction(actions)
            }
        }
        deleteAction.backgroundColor = .systemRed
        let actionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return actionsConfiguration
    }
    
}
