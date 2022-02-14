import UIKit

class NoteListViewController: UITableViewController {
    private var noteListData = [Content]() {
        didSet {
            tableView.reloadData()
        }
    }
    private weak var dataSourceDelegate: NoteListViewDelegate?

    private let addButton: UIBarButtonItem = {
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

    func setNoteListData(_ data: [Content]) {
        self.noteListData = data
    }

    func setNoteData(_ data: Content, index: Int) {
        self.noteListData[index] = data
    }

    // MARK: - Configure Navigation Bar

    private func configureNavigationBar() {
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

        cell.configureContent(for: noteListData[indexPath.row])

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSourceDelegate?.passNote(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
