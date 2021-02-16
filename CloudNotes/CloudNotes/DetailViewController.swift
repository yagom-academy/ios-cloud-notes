//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

class DetailViewController: UIViewController {
    var memoTitle: String?
    var memoBody: String?
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        setTapGesture()
    }
    
    private func setUpTextView() {
        view.addSubview(memoBodyTextView)
        guard let title = memoTitle, let body = memoBody else {
            return
        }
        let prefix = title
        let fontSize = UIFont.preferredFont(forTextStyle: .title1)
        let attributedStr = NSMutableAttributedString(string: prefix + "\n\n" + body + "\n010-1234-5678\nyagomCamp@gmail.com\n")
        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: NSMakeRange(0, prefix.count))
        memoBodyTextView.attributedText = attributedStr
        
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.resignFirstResponder()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        memoBodyTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoBodyTextView.isEditable = true
        memoBodyTextView.dataDetectorTypes = []
        memoBodyTextView.becomeFirstResponder()
    }
}
