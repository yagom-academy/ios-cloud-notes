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
    }
    
    private func setUpLayout() {
        listTableView.frame = view.bounds
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataStorage?.assetData.count ?? .zero
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteListTableViewCell else {
            return UITableViewCell()
        }
        DispatchQueue.main.async {
            cell.updateLabel(param: self.dataStorage?.assetData[indexPath.row] ?? Sample(title: "123", body: "123", lastModified: 3))
        }
        return cell
    }
}
