import UIKit

class NoteListTableViewController: UITableViewController {
    
    let noteModelManager = NoteModelManager()
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
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectNote(at: indexPath.row)
    }
    
}
