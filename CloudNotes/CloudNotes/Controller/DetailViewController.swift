import UIKit

class DetailViewController: UIViewController {
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    return textView
  }()
  
  private var memo: Memo? {
    didSet {
      refreshUI()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    setNavigationBar()
  }
  
  private func refreshUI() {
    let title = memo?.title ?? ""
    let body = memo?.body ?? ""
    textView.text = title + "\n\n" + body
  }
  
  private func setNavigationBar() {
    let buttonImage = UIImage(systemName: "ellipsis.circle")
    let ellipsisCircleButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = ellipsisCircleButton
  }
}

//MARK: - DetailViewControllerDelegate

extension DetailViewController: DetailViewControllerDelegate {
  func load(memo: Memo) {
    self.memo = memo
  }
}
