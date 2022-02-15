import UIKit

class NoteListTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Note> {
    
    private var noteModelManager: NoteModel
    
    init(
        model: NoteModel,
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<Section, Note>.CellProvider
    ) {
        noteModelManager = model
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
            noteModelManager.deleteNote(at: indexPath.row)
        }
    }
}
