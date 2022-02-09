import UIKit

class MasterTableViewController: UITableViewController {
    private var memos: [Memo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    private func configureTableView() {
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: String(describing: MasterTableViewCell.self))
    }
    
    private func fetchData() {
        guard let file = Bundle.main.path(forResource: "sample", ofType: "json") else {
            return
        }
        
        guard let data = try? String(contentsOfFile: file).data(using: .utf8) else {
            return
        }
        
        memos = try? JSONDecoder().decode([Memo].self, from: data)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MasterTableViewCell.self, for: indexPath)
        
        guard let memos = memos else {
            return UITableViewCell()
        }
        
        cell.configureUI()
        cell.applyData(memos[indexPath.row])
        
        return cell
    }
}
