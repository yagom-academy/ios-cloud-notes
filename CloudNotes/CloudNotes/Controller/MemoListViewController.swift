import UIKit

private let reuseIdentifier = "Cell"

class MemoListViewController: UIViewController {
  weak var delegate: MemoListViewControllerDelegate?
  private var memos = [Memo]()
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
    collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    return collectionView
  }()
  private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Memo> = {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Memo> { cell, _, item in
      var configuration = cell.defaultContentConfiguration()
      let title = item.title
      configuration.text = title.isEmpty ? "새로운 메모" : title
      configuration.secondaryAttributedText = item.subtitle
      configuration.textProperties.numberOfLines = 1
      configuration.secondaryTextProperties.numberOfLines = 1
      cell.contentConfiguration = configuration
      cell.accessories = [.disclosureIndicator()]
    }
    let dataSource = UICollectionViewDiffableDataSource<Int, Memo>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    }
    return dataSource
  }()
  private var memoSnapShot = NSDiffableDataSourceSnapshot<Int, Memo>()
  private lazy var listLayout: UICollectionViewCompositionalLayout = {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath -> UISwipeActionsConfiguration? in
      let actionHandler: UIContextualAction.Handler = { action, view, completion in
        guard let self = self else { return }
        completion(true)
        let item = self.memoSnapShot.itemIdentifiers[indexPath.item]
        self.memoSnapShot.deleteItems([item])
        self.dataSource.apply(self.memoSnapShot)
      }
      let action = UIContextualAction(style: .normal, title: "Delete", handler: actionHandler)
      action.image = UIImage(systemName: "trash")
      action.backgroundColor = .systemRed
      return UISwipeActionsConfiguration(actions: [action])
    }
    let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    return layout
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    setNavigationBar()
    loadJSON()
    memoSnapShot.appendSections([0])
    memoSnapShot.appendItems(memos, toSection: 0)
    dataSource.apply(memoSnapShot)
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
      collectionView.reloadData()
    } catch let error {
      print(error)
    }
  }
}

extension MemoListViewController: DetailViewControllerDelegate {
  func update(_ memo: Memo) {
    let indexPath = collectionView.indexPathsForSelectedItems?.first
    guard let index = indexPath?.row else { return }
    memos[index] = memo
    collectionView.reloadData()
    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
  }
}
