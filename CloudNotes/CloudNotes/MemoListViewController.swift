import UIKit

class MemoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpNavigationItem()
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
}

extension MemoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
}
