import UIKit

class NoteListTableViewController: UITableViewController {
    
    let noteModelManager = NoteModelManager()
    let cellId = "reuseIdentifier"
    
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
        let noteData = noteModelManager.fetchDetailData(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? NoteListTableViewCell {
            let formatter = DateFormatter()
            
            cell.titleLabel.text = noteData.title
            cell.lastModifiedLabel.text = formatter.string(from: noteData.lastModified)
            cell.bodyLabel.text = noteData.body
            return cell
        }
        
        return cell
    }
    
}
