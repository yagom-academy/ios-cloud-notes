//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class DetailViewController: UIViewController {
    var memo: Memo? {
        didSet {
            refreshUI()
        }
    }
    
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
        setupTextView()
        setupNavigationBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if traitCollection.userInterfaceIdiom == .pad &&
            UIDevice.current.orientation.isLandscape {
            navigationController?.navigationBar.isHidden = true
        }
        else {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    private func setupTextView() {
        setTapGesture()
        view.addSubview(memoBodyTextView)
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextView(_:)))
        memoBodyTextView.addGestureRecognizer(tapGesture)
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let memo = memo else {
            return
        }
        let title = memo.title
        let fontAttributeKey = NSAttributedString.Key(rawValue: kCTFontAttributeName as String)
        let fontSize = UIFont.preferredFont(forTextStyle: .title1)
        let content = NSMutableAttributedString(string: "\(memo.title)\n\n\(memo.body)")
        content.addAttribute(fontAttributeKey, value: fontSize, range: NSMakeRange(0, title.count))
        memoBodyTextView.attributedText = content
    }
}

//MARK: extension UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.resignFirstResponder()
    }
    
    @objc private func tapTextView(_ gesture: UITapGestureRecognizer) {
        memoBodyTextView.isEditable = true
        memoBodyTextView.dataDetectorTypes = []
        memoBodyTextView.becomeFirstResponder()
    }
}

extension DetailViewController: MemoSelectionDelegate {
    func memoSelected(_ memo: Memo) {
        self.memo = memo
    }
}
