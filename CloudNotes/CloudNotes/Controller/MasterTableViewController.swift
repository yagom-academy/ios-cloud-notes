import UIKit

class MasterTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        tableView.register(MasterTableViewCell.self, forCellReuseIdentifier: String(describing: MasterTableViewCell.self))
    }
    
    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .headline)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
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
