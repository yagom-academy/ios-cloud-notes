import UIKit

final class SearchResultTableViewController: UITableViewController {
    // MARK: - Properties
    private(set) var memos: [MemoEntity]?
    private(set) var filteredMemos: [MemoEntity]?
    private weak var delegate: MemoSelectionDelegate?
    
    // MARK: - Initializer
    init(style: UITableView.Style = .insetGrouped, memos: [MemoEntity]?, delegate: MemoSelectionDelegate?) {
        self.memos = memos
        self.delegate = delegate
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: MasterTableViewCell.reuseIdentifier)
    }
    
    func searchMemo(with text: String) {
        filteredMemos = memos?.filter { memo in
            ((memo.title ?? "") + (memo.body ?? "")).contains(text)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMemos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MasterTableViewCell.self, for: indexPath)
        
        guard let filteredMemos = filteredMemos else {
            return UITableViewCell()
        }
        
        cell.configureUI()
        cell.applyData(filteredMemos[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = delegate?.memoSelectionDestination as? DetailViewController else {
            return
        }

        guard let filteredMemos = filteredMemos?[indexPath.row] else {
            return
        }
 
        destination.applyData(with: filteredMemos)
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: destination), sender: self)
    }
}
