import UIKit

final class MemoListViewController: UIViewController, MemoReloadable {
    private let tableView = UITableView()
    private var memos: [Memo] = []
    private let navigationTitle = "메모"

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        setupMainListView()
    }
    
    func reload() {
        memos = CoreDataManager.shared.load()
        tableView.reloadData()
    }

    private func setupMainListView() {
        configureTableView()
        configureListView()
        configureListViewAutoLayout()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(MemoListTableViewCell.self)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Assets.plusImage,
            style: .plain,
            target: self,
            action: #selector(createMemo)
        )
    }
    
    @objc private func createMemo() {
        CoreDataManager.shared.create()
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MemoListTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setupLabel(from: memos[indexPath.row])

        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitViewController = splitViewController as? MainSplitViewController else { return }
        let selectedMemo = memos[indexPath.row]
        splitViewController.updateMemoContentsView(with: selectedMemo)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, _  in
            self.presentDeleteAlert(currentMemo: self.memos[indexPath.row])
        }
        let shareAction = UIContextualAction(style: .normal, title: "공유") { _, sourceView, _ in
            self.presentActivityViewController(currentMemo: self.memos[indexPath.row], at: sourceView)
        }
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func presentDeleteAlert(currentMemo: Memo) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManager.shared.delete(data: currentMemo)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func presentActivityViewController(currentMemo: Memo, at sourceView: UIView) {
        let memoDetail = currentMemo.entireContent
        let activityViewController = UIActivityViewController(
            activityItems: [memoDetail],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = sourceView
        present(activityViewController, animated: true)
    }
}
