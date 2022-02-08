import UIKit

final class ListViewController: UIViewController {
    private let tableView = UITableView()
    private var memos: [Memo] = []
    weak var memoDelegate: MemoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    convenience init(memos: [Memo]) {
        self.init(nibName: nil, bundle: nil)
        self.memos = memos
    }
    
    private func configure() {
        configureTableView()
        configureNavigationBar()
        configureListView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus")
    }
    
    private func configureListView() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(memo: memos[indexPath.row])
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMemo = memos[indexPath.row]
        memoDelegate?.updateTextView(with: currentMemo)
    }
}
