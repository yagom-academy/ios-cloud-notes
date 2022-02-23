import UIKit
import CoreData

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
                title: item.title,
                body: item.body,
                lastModified: self.viewModel.fetchDate(note: item))
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLayout()
        viewModel.updateUIHandler = updateUI
        viewModel.updateUIByDataHandler = updateTable
        viewModel.viewDidLoad()
        updateUI()
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
    
}
