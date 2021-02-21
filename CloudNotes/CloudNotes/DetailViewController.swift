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
        }
    }
    
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataDetectorTypes = [.link, .phoneNumber, .calendarEvent]
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setUpDefaultMemo()
        setupNavigationBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupNavigationBar()
    }
    
    private func setUpDefaultMemo() {
        let index =  UserDefaults.standard.integer(forKey: "lastMemoIndex")
        memo = MemoData.shared.list[index]
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
            memoBodyTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        let content = NSMutableAttributedString(string: memo.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        content.append(NSAttributedString(string: "\n\n" + memo.body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))

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
