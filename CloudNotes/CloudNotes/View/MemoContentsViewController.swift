import UIKit

class MemoContentsViewController: UIViewController {

    var memoTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.dataDetectorTypes = .all
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
