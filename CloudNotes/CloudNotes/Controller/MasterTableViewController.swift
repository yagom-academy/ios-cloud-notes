import UIKit

class MasterTableViewController: UITableViewController {
    var memos: [Memo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    func configureTableView() {
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: String(describing: MasterTableViewCell.self))
    }
    
    func fetchData() {
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MasterTableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(indexPath)"

        return cell
    }
}
