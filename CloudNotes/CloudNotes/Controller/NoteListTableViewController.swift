import UIKit

class NoteListTableViewController: UITableViewController {
    
    private var noteModelManager: NoteModel
    weak var delegate: NoteListTableViewDelegate?
    lazy var dataSource = {
        return NoteListTableViewDiffableDataSource(
            model: noteModelManager,
            tableView: self.tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.reuseIdentifier)
            
            if let cell = cell as? NoteListTableViewCell {
                cell.setLabelText(
                    title: item.title,
                    body: item.body,
                    lastModified: self.noteModelManager.fetchDate(at: indexPath.row)
                )
            }
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNoteData()
        configureTableView()
        configureLayout()
        self.noteModelManager.updateHandler = updateUI
        updateUI()
    }
    
    init(model: NoteModel) {
        self.noteModelManager = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(noteModelManager.noteData, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func loadNoteData() {
        noteModelManager.fetchData()
    }
    
    private func configureTableView() {
        tableView.register(NoteListTableViewCell.self)
    }
    
    private func configureLayout() {
        self.navigationController?.navigationBar.topItem?.title = "메모"
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteDidTap))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc
    func addNoteDidTap(_ sender: UIBarButtonItem) {
        noteModelManager.createNote()
    }
    
}

extension NoteListTableViewController {
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = noteModelManager.fetchTitle(at: indexPath.row)
        let body = noteModelManager.fetchBody(at: indexPath.row)
        delegate?.selectNote(title: title, body: body)
    }
    
    override func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

extension UITableView {
    
    func register<Cell: UITableViewCell>(_: Cell.Type) where Cell: TypeNameConvertible {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
}
