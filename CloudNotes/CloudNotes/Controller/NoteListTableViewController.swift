import UIKit

class NoteListTableViewController: UITableViewController {
    
    private var noteModelManager: NoteModel = NoteModelManager()
    weak var delegate: NoteListTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNoteData()
        configureTableView()
        configureLayout()
    }
    
    convenience init(model: NoteModel) {
        self.init()
        noteModelManager = model
    }
    
    private func loadNoteData() {
        noteModelManager.fetchData()
    }
    
    private func configureTableView() {
        tableView.register(NoteListTableViewCell.self)
    }
    
    private func configureLayout() {
        self.navigationController?.navigationBar.topItem?.title = "메모"
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteModelManager.countOfNoteData
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? NoteListTableViewCell {
            cell.setLabelText(
                title: noteModelManager.fetchTitle(at: indexPath.row),
                body: noteModelManager.fetchBody(at: indexPath.row),
                lastModified: noteModelManager.fetchDate(at: indexPath.row)
            )
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            noteModelManager.deleteNote(at: indexPath.row)
            tableView.reloadData()
            delegate?.selectBlankNote()
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = noteModelManager.fetchTitle(at: indexPath.row)
        let body = noteModelManager.fetchBody(at: indexPath.row)
        delegate?.selectNote(title: title, body: body)
    }
    
}

extension UITableView {
    
    func register<Cell: UITableViewCell>(_: Cell.Type) where Cell: TypeNameConvertible {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
}
