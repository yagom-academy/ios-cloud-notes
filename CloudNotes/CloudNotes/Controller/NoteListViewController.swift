import UIKit

protocol NoteListViewControllerDelegate: AnyObject {
    func noteListViewController(didSelectedCell data: Sample)
}

class NoteListViewController: UIViewController {
    var dataStorage: DataStorage?
    weak var delegate: NoteListViewControllerDelegate?
    var listTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(NoteListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataStorage = DataStorage()
        view.addSubview(listTableView)
        listTableView.dataSource = self
        listTableView.delegate = self
        setUpLayout()
        setUpNavigationItems()
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            listTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
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
        if let data = dataStorage?.assetData[safe: indexPath.row] {
            delegate?.noteListViewController(didSelectedCell: data)
        }
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
        guard let data = self.dataStorage?.assetData[safe: indexPath.row] else {
            fatalError()
        }
        cell.updateLabel(title: data.title, date: data.formattedDate, preview: data.body)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
