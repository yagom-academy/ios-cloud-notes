import UIKit

class NoteListTableViewController: UITableViewController {
    
    var noteModelManager = NoteModelManager()
    let cellId = "reuseIdentifier"
    weak var delegate: NoteDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: cellId)
        noteModelManager.fetchData()
        self.navigationController?.navigationBar.topItem?.title = "메모"
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    convenience init(model: NoteModelManager) {
        self.init()
        self.noteModelManager = model
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteModelManager.noteDataCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? NoteListTableViewCell {
            cell.titleLabel.text = noteModelManager.fetchTitle(at: indexPath.row)
            cell.lastModifiedLabel.text = noteModelManager.fetchDate(at: indexPath.row)
            cell.bodyLabel.text = noteModelManager.fetchBody(at: indexPath.row)
            return cell
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
            delegate?.selectNote(title: "", body: "")
        }
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = noteModelManager.fetchTitle(at: indexPath.row)
        let body = noteModelManager.fetchBody(at: indexPath.row)
        delegate?.selectNote(title: title, body: body)
    }
    
}
