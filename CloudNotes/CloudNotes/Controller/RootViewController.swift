import UIKit

private let reuseIdentifier = "Cell"

class RootViewController: UICollectionViewController {
  let testItem = Memo(title: "hi", body: "hello", lastModified: Date())
  
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
    self.collectionView!.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    guard let cell = cell as? UICollectionViewListCell else {
      return cell
    }
    var configuration = cell.defaultContentConfiguration()
    configuration.text = "Title"
    configuration.secondaryText = "subTitle"
    cell.contentConfiguration = configuration
    cell.accessories = [.disclosureIndicator()]
    return cell
  }
}
