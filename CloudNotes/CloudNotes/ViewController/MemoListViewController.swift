import UIKit
import CloudKit

final class MemoListViewController: UIViewController {
    private let tableView = UITableView()
    private var memos: [Memo] = []
    private var filteredMemos: [Memo] = []
    private let navigationTitle = LocalizedString.memo
    private var selectedIndexPath: IndexPath?
    private let searchController = UISearchController()
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainListView()
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
        tableView.allowsSelectionDuringEditing = true
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
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    @objc private func createMemo() {
        let newMemoIndex = IndexPath(row: 0, section: 0)
        CoreDataManager.shared.create { error in
            presentErrorAlert(errorMessage: error.localizedDescription)
        }
        changeSelectedCell(indexPath: newMemoIndex)
        tableView.selectRow(at: newMemoIndex, animated: false, scrollPosition: .none)
    }
    
    private func changeSelectedCell(indexPath: IndexPath) {
        guard let splitViewController = splitViewController as? MainSplitViewController else { return }
        let selectedMemo = isFiltering ? filteredMemos[indexPath.row] : memos[indexPath.row]
        splitViewController.updateMemoContentsView(with: selectedMemo)
        self.selectedIndexPath = indexPath
    }
}

extension MemoListViewController: MemoReloadable {
    func reload() {
        memos = CoreDataManager.shared.load { error in
            presentErrorAlert(errorMessage: error.localizedDescription)
        }
        tableView.reloadData()
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
}

// MARK: - TableViewDataSource
extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredMemos.count : memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MemoListTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        if isFiltering {
            cell.setupLabel(from: filteredMemos[indexPath.row])
        } else {
            cell.setupLabel(from: memos[indexPath.row])
        }
        return cell
    }
}

// MARK: - TableViewDelegate
extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeSelectedCell(indexPath: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: LocalizedString.delete) { _, _, _  in
            if self.isFiltering {
                self.presentDeleteAlert(currentMemo: self.filteredMemos[indexPath.row])
            } else {
                self.presentDeleteAlert(currentMemo: self.memos[indexPath.row])
            }
        }
        let shareAction = UIContextualAction(style: .normal, title: LocalizedString.share) { _, sourceView, _ in
            if self.isFiltering {
                self.presentActivityViewController(currentMemo: self.filteredMemos[indexPath.row], at: sourceView)
            } else {
                self.presentActivityViewController(currentMemo: self.memos[indexPath.row], at: sourceView)
            }
        }
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = nil
    }
    
    private func presentDeleteAlert(currentMemo: Memo) {
        let alert = UIAlertController(
            title: LocalizedString.deleteAlertTitle,
            message: LocalizedString.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: LocalizedString.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: LocalizedString.delete, style: .destructive) { _ in
            CoreDataManager.shared.delete(data: currentMemo) { error in
                self.presentErrorAlert(errorMessage: error.localizedDescription)
            }
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
    
    private func presentErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedString.close, style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filteredMemos = memos.filter {
            guard let title = $0.title?.lowercased() else {
                return false
            }
            return title.contains(text)
        }
        tableView.reloadData()
    }
}
