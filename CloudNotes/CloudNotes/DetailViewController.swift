//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class DetailViewController: UIViewController {
    private var memo: Memo? {
        didSet {
            refreshUI()
            memoBodyTextView.isEditable = false
        }
    }
    
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextView()
        setupNavigationBar()
        setupKeyboardDoneButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let isRegular = traitCollection.horizontalSizeClass == .regular
        navigationController?.navigationBar.isHidden = isRegular
    }
    
    private func setupTextView() {
        setTapGesture()
        memoBodyTextView.delegate = self
        memoBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoBodyTextView)
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        tapGesture.delegate = self
        memoBodyTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        if memoBodyTextView.isEditable {
            return
        }
        
        guard let textView = gesture.view as? UITextView else {
            return
        }
        
        let tappedLocation = gesture.location(in: textView)
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            memoBodyTextView.isEditable = true
            placeCursor(textView, tappedLocation)
            memoBodyTextView.becomeFirstResponder()
        }
    }
    
    private func placeCursor(_ textView: UITextView, _ tappedLocation: CGPoint) {
        if let position = textView.closestPosition(to: tappedLocation) {
            let uiTextRange = textView.textRange(from: position, to: position)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let loc = textView.offset(from: textView.beginningOfDocument, to: position)
                let length = textView.offset(from: start, to: end)
                textView.selectedRange = NSMakeRange(loc, length)
            }
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memo = memo else {
            return
        }
        let content = NSMutableAttributedString(string: memo.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSAttributedString(string: "\n\n" + memo.body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))

        memoBodyTextView.attributedText = content
    }
    
    
    private func setupKeyboardDoneButton() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        memoBodyTextView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.memoBodyTextView.endEditing(true)
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
    }
}

extension DetailViewController: MemoSelectionDelegate {
    func memoSelected(_ memo: Memo) {
        self.memo = memo
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
