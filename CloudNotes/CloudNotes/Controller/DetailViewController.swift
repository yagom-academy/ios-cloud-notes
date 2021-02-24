//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo: Memo?
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setTapGesture()
        setNavigation()
    }
    
    private func setNavigation() {
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapEllipsisButton))
    }
    
    @objc private func didTapEllipsisButton() {
        
    }

    private func setTextView() {
        memoTextView.delegate = self
        setPropertyStyle()
        addSubview()
        setAutoLayout()
    }
    
    private func setPropertyStyle() {
        memoTextView.text = memo?.title
        guard let contentText: String = memo?.contents else {
            return
        }
        memoTextView.text += "\n\n\(contentText)"
        memoTextView.text += "\n 010-1234-1234 \n www.naver.com \n"
    }

    private func addSubview() {
        view.addSubview(memoTextView)
    }

    private func setAutoLayout() {
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

// MARK: GestureRecognizer
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
