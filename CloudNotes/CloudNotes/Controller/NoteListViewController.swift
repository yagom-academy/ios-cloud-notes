import UIKit

class NoteListViewController: UIViewController {
    var dataStorage: DataStorage?
    private var listTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorage = DataStorage()
        view.backgroundColor = .white
        view.addSubview(listTableView)
        listTableView.dataSource = self
        listTableView.delegate = self
        setUpLayout()
        setUpNavigationItems()
    }
    
    private func setUpLayout() {
        listTableView.frame = view.bounds
    }
    
    func setUpNavigationItems() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: nil,
            action: nil
        )
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension NoteListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataStorage?.assetData.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? NoteListTableViewCell else {
            return UITableViewCell()
        }
        cell.updateLabel(
            param: self.dataStorage?.assetData[indexPath.row] ??
            Sample(title: "123", body: "123", lastModified: 3)
        )
        return cell
    }
}
