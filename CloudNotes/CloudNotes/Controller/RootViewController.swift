import UIKit

private let reuseIdentifier = "Cell"

class RootViewController: UICollectionViewController {
  private var memos = [Memo]()
  weak var delegate: DetailViewControllerDelegate?
  
  init() {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.trailingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration? in
      let actionHandler: UIContextualAction.Handler = { action, view, completion in
      }
      
      let action = UIContextualAction(style: .normal, title: "Delete", handler: actionHandler)
      action.image = UIImage(systemName: "trash")
      action.backgroundColor = .systemRed
      
      return UISwipeActionsConfiguration(actions: [action])
    }
    let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    super.init(collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    setNavigationBar()
  }
  
  private func setNavigationBar() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    navigationItem.rightBarButtonItem = addButton
    navigationItem.title = "메모"
  }
  
  @objc private func addMemo() {
    let newMemo = Memo(title: "", body: "", lastModified: Date())
    memos.append(newMemo)
    collectionView.reloadData()
  }
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    guard let listCell = cell as? UICollectionViewListCell else {
      return cell
    }
    var configuration = listCell.defaultContentConfiguration()
    let title = memos[indexPath.row].title
    configuration.text = title.isEmpty ? "새로운 메모" : title
    configuration.secondaryAttributedText = memos[indexPath.row].subtitle
    configuration.textProperties.numberOfLines = 1
    configuration.secondaryTextProperties.numberOfLines = 1
    listCell.contentConfiguration = configuration
    listCell.accessories = [.disclosureIndicator()]
    return listCell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let memo = memos[indexPath.row]
    delegate?.load(memo: memo)
  }
}
