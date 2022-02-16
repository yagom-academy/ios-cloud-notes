import UIKit

class NoteListViewController: UITableViewController {
    private var noteListData = [Content]()
    private weak var dataSourceDelegate: NoteListViewDelegate?

    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "plus")
        button.target = self
        button.action = #selector(touchUpPlusButton)
        return button
    }()


    private lazy var activityController: UIActivityViewController = {
        let controller = UIActivityViewController(
            activityItems: ["memo"],
            applicationActivities: nil
        )

        return controller
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

    func showActivityController() {
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
    }

    func showDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "메모를 삭제하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            let note = self.noteListData[indexPath.row]
            self.dataSourceDelegate?.deleteNote(note, index: indexPath.row)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func delete(at index: Int) {
        self.noteListData.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }

    // MARK: - Manipulate DataSource

    func setNoteListData(_ data: [Content]) {
        self.noteListData = data
        tableView.reloadData()
    }

    @objc func touchUpPlusButton() {
        self.dataSourceDelegate?.creatNote()
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
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(
            style: .normal,
            title: "공유"
        ) { action, view, completionHandler in
            self.showActivityController()
            completionHandler(true)
        }

        let delete = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { action, view, completionHandler in
            self.showDeleteAlert(indexPath: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [share, delete])
    }
}
