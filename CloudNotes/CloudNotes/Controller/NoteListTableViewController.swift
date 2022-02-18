import UIKit

class NoteListTableViewController: UITableViewController {
    
    private var viewModel: NoteViewModel
    weak var delegate: NoteListTableViewDelegate?
    lazy var dataSource = {
        return NoteListTableViewDiffableDataSource(
            model: viewModel,
            tableView: self.tableView) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.reuseIdentifier)
            
            if let cell = cell as? NoteListTableViewCell {
                cell.setLabelText(
                    title: item.title,
                    body: item.body,
                    lastModified: self.viewModel.fetchDate(note: item)
                )
            }
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLayout()
        viewModel.updateHandler = updateUI
        viewModel.viewDidLoad()
        updateUI()
    }
    
    init(model: NoteViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.noteData, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureTableView() {
        tableView.register(NoteListTableViewCell.self)
    }
    
    private func configureLayout() {
        self.navigationController?.navigationBar.topItem?.title = "메모"
        let addBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteDidTap))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc
    func addNoteDidTap(_ sender: UIBarButtonItem) {
        viewModel.createNote()
    }
    
}

extension NoteListTableViewController {
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        guard let identifier = item?.identifier else {
            return
        }
        delegate?.selectNote(with: identifier)
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
