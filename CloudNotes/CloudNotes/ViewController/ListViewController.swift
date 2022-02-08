import UIKit

final class ListViewController: UIViewController {
    private let tableView = UITableView()
    private var memos: [Memo] = []
    private let navigationTitle = "메모"
    private let navigationButtonImageName = "plus"
    weak var memoViewController: MemoViewController?

    convenience init(memos: [Memo]) {
        self.init(nibName: nil, bundle: nil)
        self.memos = memos
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainListView()
    }
    
    private func setupMainListView() {
        configureTableView()
        configureListView()
        configureListViewAutoLayout()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }

    private func configureListView() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureListViewAutoLayout() {
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }
    
    private func configureNavigationBar() {
        navigationItem.title = navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: navigationButtonImageName)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
        guard let listCell = cell as? ListTableViewCell else {
            return UITableViewCell()
        }
        listCell.setupLabel(from: memos[indexPath.row])

        return listCell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoViewController = memoViewController else { return }
        let selectedMemo = memos[indexPath.row]
        memoViewController.updateTextView(with: selectedMemo)
        showDetailViewController(memoViewController, sender: nil)
    }
}
