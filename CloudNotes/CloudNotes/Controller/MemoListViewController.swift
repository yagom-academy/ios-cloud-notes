import UIKit

private let reuseIdentifier = "Cell"

class MemoListViewController: UIViewController {
  weak var delegate: MemoListViewControllerDelegate?
  private var memos = [Memo]()
  private var tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    setNavigationBar()
    loadJSON()
    let firstRowIndexPath = IndexPath(row: 0, section: 0)
    tableView.selectRow(at: firstRowIndexPath, animated: false, scrollPosition: .top)
    loadDetail(at: firstRowIndexPath)
  }

  private func setNavigationBar() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    navigationItem.rightBarButtonItem = addButton
    navigationItem.title = "메모"
  }

  @objc private func addMemo() {
    let newMemo = Memo(title: "", body: "", lastModified: Date())
    memos.insert(newMemo, at: 0)
    let firstCellIndexPath = IndexPath(row: 0, section: 0)
    tableView.reloadData()
    tableView.selectRow(at: firstCellIndexPath, animated: true, scrollPosition: .top)
    loadDetail(at: firstCellIndexPath)
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
    delegate?.load(memo: memo)
  }
}

extension MemoListViewController: DetailViewControllerDelegate {
  func update(_ memo: Memo) {
    let indexPath = tableView.indexPathsForSelectedRows?.first
    guard let index = indexPath?.row else { return }
    memos[index] = memo
    tableView.reloadData()
    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
  }
}

extension MemoListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

extension MemoListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    loadDetail(at: indexPath)
  }
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
      self.memos.remove(at: indexPath.row)
      if self.memos.isEmpty {
        self.addMemo()
      } else {
        tableView.reloadData()
        let firstRowIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: firstRowIndexPath, animated: false, scrollPosition: .top)
        self.loadDetail(at: firstRowIndexPath)
      }
      completionHandler(true)
    }
    deleteAction.image = UIImage(systemName: "trash")
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
}
