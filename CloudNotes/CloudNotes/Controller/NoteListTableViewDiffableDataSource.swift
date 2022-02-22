import UIKit

final class NoteListTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Note> {
    
    private var viewModel: NoteViewModel
    
    init(
        model: NoteViewModel,
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<Section, Note>.CellProvider
    ) {
        viewModel = model
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let item = itemIdentifier(for: indexPath)
            guard let identifier = item?.identifier else {
                return
            }
            viewModel.deleteNote(identifier: identifier)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        }
    }
    
}
