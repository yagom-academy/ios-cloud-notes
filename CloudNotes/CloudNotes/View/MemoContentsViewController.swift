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
        
        configureView()
        configureAutoLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(memoTextView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func receiveText(memo: Memo) {
        let title = memo.title
        let body = "\n" + "\n" + memo.body
        let titleFontSize = UIFont.preferredFont(forTextStyle: .largeTitle)
        let bodyFontSize = UIFont.preferredFont(forTextStyle: .body)
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: titleFontSize])
        attributedText.append(NSAttributedString(string: body, attributes: [.font: bodyFontSize]))
        
        memoTextView.attributedText = attributedText
    }
}
