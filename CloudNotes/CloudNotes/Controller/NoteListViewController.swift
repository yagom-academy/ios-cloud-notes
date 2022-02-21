import UIKit

protocol NoteListViewControllerDelegate: AnyObject {
    func noteListViewController(
        _ viewController: NoteListViewController,
        didSelectedCell indexPath: IndexPath
    )
    
    func noteListViewController(addButtonTapped viewController: NoteListViewController)
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToDelete indexPath: IndexPath
    )
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToShare indexPath: IndexPath
    )
}

protocol NoteListViewControllerDataSource: AnyObject {
    func noteListViewControllerNumberOfData(
        _ viewController: NoteListViewController
    ) -> Int
    func noteListViewControllerSampleForCell(
        _ viewController: NoteListViewController,
        indexPath: IndexPath
    ) -> CDMemo?
}

class NoteListViewController: UIViewController {
    weak var delegate: NoteListViewControllerDelegate?
    weak var dataSource: NoteListViewControllerDataSource?
    private var listTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(cellWithClass: NoteListTableViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelectionDuringEditing = false
        return tableView
    }()
    
    override func loadView() {
        view = .init()
        view.backgroundColor = .white
        view.addSubview(listTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func setUpNavigationItems() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tappedPlusButton)
        )
    }

    @objc private func tappedPlusButton() {
        delegate?.noteListViewController(addButtonTapped: self)
    }
    
    func updateTableView() {
        listTableView.reloadData()
    }
    
    func extractSeletedRow() -> IndexPath? {
        listTableView.indexPathForSelectedRow
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.noteListViewController(self, didSelectedCell: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(
            style: .normal,
            title: nil) { [weak self] _, _, _ in
                self?.delegate?.noteListViewController(self ?? NoteListViewController(), cellToShare: indexPath)
            }
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] _, _, _ in
                self?.delegate?.noteListViewController(
                    self ?? NoteListViewController(),
                    cellToDelete: indexPath
                )
            tableView.reloadData()
            })
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let actionConfigurations = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return actionConfigurations
    }
    
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.noteListViewControllerNumberOfData(self) ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withClass: NoteListTableViewCell.self,
            for: indexPath)
        
        guard let data = dataSource?.noteListViewControllerSampleForCell(
            self,
            indexPath: indexPath
        ) else {
            return UITableViewCell()
        }
        
        guard let title = data.title, let preview = data.body, let lastModified = data.lastModified else {
            return UITableViewCell()
        }
        
        cell.updateLabel(title: title, lastModified: lastModified, preview: preview)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
