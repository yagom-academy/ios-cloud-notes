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

}
