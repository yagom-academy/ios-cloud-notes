import UIKit

protocol MemoDetailViewControllerDelegate: AnyObject {
    func memoDetailViewController(didChangeTextViewWith data: Memo)
}

class MemoDetailViewController: UIViewController {
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextView()
        setupNavigationItem()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(showActivityView)
        )
    }
    
    @objc func showActivityView() {
        print("AA")
    }
    
}

extension MemoDetailViewController: MemoDetailViewControllerDelegate {
    func memoDetailViewController(didChangeTextViewWith memo: Memo) {
        textView.text = "\(memo.title)\n\(memo.body)"
    }
}
