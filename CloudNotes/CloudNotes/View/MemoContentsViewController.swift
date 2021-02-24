import UIKit

class MemoContentsViewController: UIViewController {
    private let disclosureButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
    private let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(dismissButton))
    
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
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowTableView"), object: nil)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [disclosureButton]
    }
    
    private func configureMemoContentsView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        tapGesture.delegate = self
        
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
        let body = "\n" + "\n" + "010-2222-4444 " + memo.body + "\n" + "https://www.google.com"
        let titleFontSize = UIFont.preferredFont(forTextStyle: .largeTitle)
        let bodyFontSize = UIFont.preferredFont(forTextStyle: .body)
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: titleFontSize])
        attributedText.append(NSAttributedString(string: body, attributes: [.font: bodyFontSize]))
        
        memoTextView.attributedText = attributedText
    }
    
    @objc func dismissButton(_ sender: UIButton) {
        memoTextView.resignFirstResponder()
        navigationItem.rightBarButtonItems?.removeFirst()
    }
}

// MARK: UITextViewDelegate
extension MemoContentsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.isEditable = false
    }
}

// MARK: dataDetectorTypes & isEditable
extension MemoContentsViewController {
    @objc func textViewDidTapped(_ recognizer: UITapGestureRecognizer) {
        if memoTextView.isEditable { return }
        
        guard let textView = recognizer.view as? UITextView else {
            return
        }
        let tappedLocation = recognizer.location(in: textView)
        
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            placeCursor(textView, tappedLocation)
            makeTextViewEditable()
            navigationItem.rightBarButtonItems?.insert(finishButton, at: 0)
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

// MARK: UIGestureRecognizerDelegate
extension MemoContentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
