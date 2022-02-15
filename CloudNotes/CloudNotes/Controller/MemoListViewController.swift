import UIKit

private let reuseIdentifier = "Cell"

final class MemoListViewController: UITableViewController {
  weak var delegate: MemoDisplayable?
  private var memos = [Memo]()
  private let firstRowIndexPath = IndexPath(row: 0, section: 0)
  private var currentMemoIndexPath = IndexPath(row: 0, section: 0)
  private var keyboardShowNotification: NSObjectProtocol?
  private var keyboardHideNotification: NSObjectProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.allowsSelectionDuringEditing = true
    loadJSON()
    loadDetail(at: firstRowIndexPath)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.selectRow(at: currentMemoIndexPath, animated: false, scrollPosition: .top)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    addObservers()
  }

  override func viewDidDisappear(_ animated: Bool) {
    removeObservers()
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.selectRow(at: currentMemoIndexPath, animated: false, scrollPosition: .none)
  }

  private func addObservers() {
    let bottomInset = view.safeAreaInsets.bottom
    let addSafeAreaInset: (Notification) -> Void = { [weak self] notification in
      guard
        let self = self,
        let userInfo = notification.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
      }
      self.additionalSafeAreaInsets.bottom = keyboardFrame.height - bottomInset
    }
    let removeSafeAreaInset: (Notification) -> Void = { [weak self] _ in
      self?.additionalSafeAreaInsets.bottom = 0
    }
    
    if keyboardShowNotification == nil {
      keyboardShowNotification = NotificationCenter.default.addObserver(
        forName: UIResponder.keyboardWillShowNotification,
        object: nil,
        queue: nil,
        using: addSafeAreaInset
      )
    }
    if keyboardHideNotification == nil {
      keyboardHideNotification = NotificationCenter.default.addObserver(
        forName: UIResponder.keyboardWillHideNotification,
        object: nil,
        queue: nil,
        using: removeSafeAreaInset
      )
    }
  }

  private func removeObservers() {
    if let keyboardShowNotification = keyboardShowNotification {
      NotificationCenter.default.removeObserver(keyboardShowNotification)
      self.keyboardShowNotification = nil
    }
    if let keyboardHideNotification = keyboardHideNotification {
      NotificationCenter.default.removeObserver(keyboardHideNotification)
      self.keyboardHideNotification = nil
    }
  }

  private func setNavigationBar() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    navigationItem.rightBarButtonItem = addButton
    navigationItem.title = "메모"
  }

  @objc private func addMemo() {
    let newMemo = Memo(title: "", body: "", lastModified: Date())
    if memos.isEmpty {
      memos.append(newMemo)
      tableView.reloadRows(at: [firstRowIndexPath], with: .fade)
    } else {
      memos.insert(newMemo, at: 0)
      tableView.insertRows(at: [firstRowIndexPath], with: .fade)
    }
    tableView.selectRow(at: firstRowIndexPath, animated: true, scrollPosition: .top)
    loadDetail(at: firstRowIndexPath)
  }
  
  private func loadJSON() {
    guard let data = NSDataAsset(name: "memo")?.data else {
      return
    }
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      decoder.dateDecodingStrategy = .secondsSince1970
      let memo = try decoder.decode([Memo].self, from: data)
      memos.append(contentsOf: memo)
      tableView.reloadData()
    } catch let error {
      print(error)
    }
  }

  private func loadDetail(at indexPath: IndexPath) {
    let memo = memos[indexPath.row]
    currentMemoIndexPath = indexPath
    delegate?.show(memo: memo)
  }
}

// MARK: - MemoStorable

extension MemoListViewController: MemoStorable {
  func update(_ memo: Memo) {
    let index = currentMemoIndexPath.row
    memos[index] = memo
    tableView.reloadData()
    tableView.selectRow(at: currentMemoIndexPath, animated: false, scrollPosition: .none)
  }
}

// MARK: - UITableViewDataSource

extension MemoListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    let memo = memos[indexPath.row]
    var configuration = cell.defaultContentConfiguration()
    let title = memo.title
    configuration.text = title.isEmpty ? "새로운 메모" : title
    configuration.secondaryAttributedText = memo.subtitle
    configuration.textProperties.numberOfLines = 1
    configuration.secondaryTextProperties.numberOfLines = 1
    cell.contentConfiguration = configuration
    cell.accessoryType = .disclosureIndicator
    return cell
  }
}

// MARK: - UITableViewDelegate

extension MemoListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    loadDetail(at: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
      self.memos.remove(at: indexPath.row)
      if self.memos.isEmpty {
        self.addMemo()
      } else {
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.currentMemoIndexPath.row -= self.currentMemoIndexPath.row > indexPath.row ?  1 : 0
      }
      completionHandler(true)
    }
    deleteAction.image = UIImage(systemName: "trash")
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
  
  override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    let section = currentMemoIndexPath.section
    let numberOfRows = tableView.numberOfRows(inSection: section)
    let maximumVaildRow = numberOfRows - 1
    let willSelectIndexPath: IndexPath
    
    if maximumVaildRow < currentMemoIndexPath.row {
      willSelectIndexPath = IndexPath(row: maximumVaildRow, section: section)
    } else if numberOfRows > 1 {
      willSelectIndexPath = currentMemoIndexPath
    } else {
      willSelectIndexPath = firstRowIndexPath
    }
    tableView.selectRow(at: willSelectIndexPath, animated: false, scrollPosition: .none)
    self.loadDetail(at: willSelectIndexPath)
  }
}
