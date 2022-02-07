import UIKit

class MemoViewController: UIViewController {
    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "ellipsis.circle")
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        
    }
}
