import UIKit

class NotesViewController: UITableViewController {
    private enum Constant {
        static let navigationTitle = "메모"
        static let lastModified = "lastModified"
        static let id = "id"
        static let deleteIconName = "trash.fill"
        static let shareIconName = "square.and.arrow.up"
    }
    weak var delegate: NotesDetailViewControllerDelegate?
    private var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        tableView.allowsSelectionDuringEditing = true
        tableView.register(NotesCell.self, forCellReuseIdentifier: NotesCell.identifier)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        if editing == false {
            delegate?.clearTextView()
            showNoteDetailView()
        }
    }
    
    private func showNoteDetailView() {
        guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
            return
        }
        delegate?.updateData(with: selectedIndex?.row ?? .zero)
        splitViewController?.show(.secondary)
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = Constant.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tappedAddButton)
        )
    }
}

// MARK: - Add
extension NotesViewController {
    @objc private func tappedAddButton() {
        let newNote: [String : Any] = [
            Constant.lastModified: Date().timeIntervalSince1970,
            Constant.id: UUID()
        ]
        PersistentManager.shared.insert(items: newNote)
        insertCell()
    }
    
    private func insertCell() {
        guard let newData = PersistentManager.shared.fetch()?.first else {
            return
        }
        let newIndexPath = IndexPath(row: .zero, section: .zero)
        PersistentManager.shared.insertNote(newData)
        delegate?.updateData(with: .zero)
        splitViewController?.show(.secondary)
        tableView.insertRows(at: [newIndexPath], with: .fade)
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
        selectedIndex = newIndexPath
    }
}

// MARK: - UITableViewDataSource
extension NotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersistentManager.shared.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotesCell.identifier,
            for: indexPath
        ) as? NotesCell else {
            return UITableViewCell()
        }
        cell.configure(with: PersistentManager.shared.notes[safe: indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateData(with: indexPath.row)
        splitViewController?.show(.secondary)
        selectedIndex = indexPath
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completeHandeler in
            self.deleteCell(indexPath: indexPath)
            completeHandeler(true)
        }
        deleteAction.image = UIImage(systemName: Constant.deleteIconName)
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, completeHandeler in
            self.showActivityView(at: indexPath.row)
            completeHandeler(true)
        }
        shareAction.image = UIImage(systemName: Constant.shareIconName)
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func showActivityView(at index: Int) {
        self.showActivityViewController(data: PersistentManager.shared.notes[index].body ?? "")
    }
}

// MARK: - NotesViewControllerDelegate
extension NotesViewController: NotesViewControllerDelegate {
    func updateData(at index: Int) {
        guard self.tableView.numberOfRows(inSection: .zero) != .zero else {
            return
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: .zero)], with: .none)
        tableView.selectRow(at: IndexPath(row: .zero, section: .zero), animated: false, scrollPosition: .middle)
    }
    
    func moveCell(at index: Int) {
        let newIndexPath = IndexPath(row: .zero, section: .zero)
        tableView.moveRow(
            at: IndexPath(row: index, section: .zero),
            to: newIndexPath
        )
        tableView.selectRow(at: newIndexPath, animated: false, scrollPosition: .middle)
    }

    func deleteCell(indexPath: IndexPath) {
        let item = PersistentManager.shared.removeNote(at: indexPath.row)
        PersistentManager.shared.delete(item)
        tableView.deleteRows(at: [indexPath], with: .fade)
        changeSelectedIndex(indexPath: indexPath)
    }
    
    private func changeSelectedIndex(indexPath: IndexPath) {
        guard tableView.numberOfRows(inSection: .zero) > .zero else {
            selectedIndex = nil
            return
        }
        if let selectedIndex = selectedIndex, selectedIndex >= indexPath {
            self.selectedIndex?.row = selectedIndex.row - 1 > 0 ? selectedIndex.row - 1 : 0
        }
    }
}
