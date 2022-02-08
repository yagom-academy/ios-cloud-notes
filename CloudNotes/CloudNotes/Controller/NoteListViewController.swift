import UIKit

class NoteListViewController: UITableViewController {
    var noteData = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.reuseIdentifer
        )
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteListCell.reuseIdentifer,
            for: indexPath
        ) as? NoteListCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = noteData[indexPath.row].title
        cell.dateLabel.text = noteData[indexPath.row].formattedDateString
        cell.previewLabel.text = noteData[indexPath.row].body

        return cell
    }
}
