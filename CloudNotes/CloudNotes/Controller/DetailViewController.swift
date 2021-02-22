//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

class DetailViewController: UIViewController {
    var memo: Memo?
    
    private var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setTapGesture()
    }
    
    private func setTextView() {
        updateTextView()
        configure()
        addSubView()
        setAutoLayout()
    }
    
    private func updateTextView() {
        navigationItem.title = memo?.title
        memoTextView.text = memo?.contents
    }
    
    private func configure() {
        memoTextView.delegate = self
    }
    
    private func addSubView() {
        view.addSubview(memoTextView)
    }

    private func setAutoLayout() {
        view.backgroundColor = .white
        let magin: CGFloat = 10
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: guide.topAnchor, constant: magin),
            memoTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: magin),
            memoTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -magin),
            memoTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -magin)
        ])
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.isEditable = false
    }
}

extension DetailViewController {
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedTextView(_:)))
        tapGesture.delegate = self
        memoTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTappedTextView(_ gestrue: UITapGestureRecognizer) {
        if memoTextView.isEditable {
            return
        }
        
        guard let textView = gestrue.view as? UITextView else {
            return
        }
        
        let tappedLocation = gestrue.location(in: textView)
        let glyphIndex = textView.layoutManager.glyphIndex(for: tappedLocation, in: textView.textContainer)
        
        if glyphIndex < textView.textStorage.length,
           textView.textStorage.attribute(NSAttributedString.Key.link, at: glyphIndex, effectiveRange: nil) == nil {
            memoTextView.isEditable = true
            placeCursor(textView, tappedLocation)
            memoTextView.becomeFirstResponder()
        }
    }
    
    private func placeCursor(_ textView: UITextView, _ tappedLocation: CGPoint) {
        if let position = textView.closestPosition(to: tappedLocation) {
            let uiTextRange = textView.textRange(from: position, to: position)
            
            if let start = uiTextRange?.start, let end = uiTextRange?.end {
                let location = textView.offset(from: textView.beginningOfDocument, to: position)
                let length = textView.offset(from: start, to: end)
                textView.selectedRange = NSMakeRange(location, length)
            }
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
