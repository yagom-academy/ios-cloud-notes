import UIKit

class MemoContentsViewController: UIViewController {

    private var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(memoTextView)
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setText(memo: Memo) {
        self.memoTextView.text = memo.title + memo.body
    }
}
