import UIKit

protocol MemoSelectionDelegate: AnyObject {
    var memoSelectionDestination: UIViewController { get }
    func applyData(with data: Memo)
}

final class MasterTableViewController: UITableViewController {
    // MARK: - Properties
    var memoDataSource: MasterTableViewDataSourceProtocol?
    weak var delegate: MemoSelectionDelegate?
    
    // MARK: - Initializer
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience init(style: UITableView.Style, dataSource: MasterTableViewDataSourceProtocol = MasterTableViewDataSource(), delegate: MemoSelectionDelegate) {
        self.init(style: style)
        self.memoDataSource = dataSource
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstMemo()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        let addMemoButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(touchUpAddMemoButton))
        navigationItem.rightBarButtonItem = addMemoButton
    }
    
    @objc func touchUpAddMemoButton() {
        let memo = TemporaryMemo(title: "안녕하세요", body: "안녕히가세요", lastModifiedDate: 1231232213, id: UUID()) // Test
        let request = Memo.fetchRequest()
        
        CoreDataManager.shared.saveContext(memo: memo)
        memoDataSource?.memos = CoreDataManager.shared.fetch(request)
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.dataSource = memoDataSource as? UITableViewDataSource
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: MasterTableViewCell.reuseIdentifier)
    }
    
    private func selectFirstMemo() {
        if memoDataSource?.memos?.count != 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memos = memoDataSource?.memos else {
            return
        }
        
        guard let destination = delegate?.memoSelectionDestination as? DetailViewController else {
            return
        }
        
        destination.applyData(with: memos[indexPath.row])
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: destination), sender: self)
    }
}
