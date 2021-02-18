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
        
        configureMemoContentsView()
        configureAutoLayout()
    }
    
    private func configureMemoContentsView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        memoTextView.delegate = self
        memoTextView.isEditable = false
        memoTextView.addGestureRecognizer(tapGesture)
        
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
        let body = "\n" + "\n" + "010-2222-4444 " + memo.body
        let titleFontSize = UIFont.preferredFont(forTextStyle: .largeTitle)
        let bodyFontSize = UIFont.preferredFont(forTextStyle: .body)
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: titleFontSize])
        attributedText.append(NSAttributedString(string: body, attributes: [.font: bodyFontSize]))
        
        memoTextView.attributedText = attributedText
    }
}

extension MemoContentsViewController: UITextViewDelegate {
    
}

// MARK: dataDetectorTypes & isEditable
extension MemoContentsViewController {
    @objc func textViewDidTapped(_ recognizer: UITapGestureRecognizer) {
        if "UIDataDetectorTypes을 터치했을때" == nil {
            return
        } else if let textView = recognizer.view as? UITextView {
            var location = recognizer.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            
            placeCursor(textView, location)
            makeTextViewEditable()
        }
    }
    
    private func placeCursor(_ myTextView: UITextView, _ location: CGPoint) {
        if let tapPosition = myTextView.closestPosition(to: location) {
            let uiTextRange = myTextView.textRange(from: tapPosition, to: tapPosition)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = myTextView.offset(from: myTextView.beginningOfDocument, to: tapPosition)
                let length = myTextView.offset(from: start, to: end)
                myTextView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    private func makeTextViewEditable() {
        memoTextView.isEditable = true
        memoTextView.becomeFirstResponder()
    }
}
