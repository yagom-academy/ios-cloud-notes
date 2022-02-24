import UIKit

final class NoteTableViewDiffableDataSource: UITableViewDiffableDataSource<NoteTableViewController.Section, Note> {
    
    private let viewModel: NoteViewModel
    
    init(
        model: NoteViewModel,
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<NoteTableViewController.Section, Note>.CellProvider
    ) {
        viewModel = model
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
