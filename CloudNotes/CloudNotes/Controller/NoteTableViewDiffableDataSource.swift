import UIKit

final class NoteTableViewDiffableDataSource: UITableViewDiffableDataSource<NoteTableViewController.Section, Note> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
