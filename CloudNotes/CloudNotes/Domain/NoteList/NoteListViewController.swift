import UIKit

class NoteListViewController: UITableViewController {
    var noteListData = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    private weak var dataSourceDelegate: NoteListViewDelegate?

    let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "plus")

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: String(describing: NoteListCell.self)
        )

        configureNavigationBar()
    }

    func setDelegate(delegate: NoteListViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    // MARK: - Configure Navigation Bar

    func configureNavigationBar() {
        self.title = "메모"

        self.navigationItem.rightBarButtonItem = addButton
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListData.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteListCell.self),
            for: indexPath
        ) as? NoteListCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = noteListData[indexPath.row].title
        cell.dateLabel.text = noteListData[indexPath.row].formattedDateString
        cell.previewLabel.text = noteListData[indexPath.row].body

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSourceDelegate?.passNote(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
