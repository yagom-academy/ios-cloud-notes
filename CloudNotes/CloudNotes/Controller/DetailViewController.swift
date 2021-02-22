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
        addSubView()
        setAutoLayout()
    }
    
    private func updateTextView() {
        navigationItem.title = memo?.title
        memoTextView.text = memo?.contents
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

extension DetailViewController {
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedTextView(_:)))
        tapGesture.delegate = self
        memoTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTappedTextView(_ gestrue: UITapGestureRecognizer) {
        
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
