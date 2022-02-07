import UIKit

class ListViewController: UIViewController {
    private let tableView = UITableView()
    private var memos: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus")
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    convenience init(memos: [Memo]) {
        self.init(nibName: nil, bundle: nil)
        self.memos = memos
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
