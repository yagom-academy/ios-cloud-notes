//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    weak var delegate: DetailMemoDelegate?
    var index = IndexPath()

    var memo: Memo? {
        didSet {
            configureText()
        }
    }
    
    private var detailMemoTextView: UITextView = {
        let detailMemoTextView = UITextView()
        detailMemoTextView.font = UIFont.systemFont(ofSize: 20)
        detailMemoTextView.translatesAutoresizingMaskIntoConstraints = false
        return detailMemoTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailMemoTextView.delegate = self
        view.backgroundColor = .white
        addSubView()
        configureAutoLayout()
        configureNavigationItem()
        configureText()
        registerNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        
        detailMemoTextView.contentInset = contentInset
        detailMemoTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        detailMemoTextView.contentInset = contentInset
        detailMemoTextView.scrollIndicatorInsets = contentInset
    }
    
    private func configureText() {
        memo.flatMap { detailMemoTextView.text = $0.title + "\n\n" + $0.body }
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func addSubView() {
        view.addSubview(detailMemoTextView)
    }
    
    private func configureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailMemoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailMemoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailMemoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailMemoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let minumumLine = 3
        let title = detailMemoTextView.text.lines[0]
        var body = ""
        
        if minumumLine <= detailMemoTextView.text.lines.count {
            body = detailMemoTextView.text.lines[(minumumLine - 1)...].joined(separator: "\n")
        }
        
        let newMemo = Memo(title: title, body: body, date: Date().timeIntervalSince1970)
        memo = newMemo
        guard let savedMemo = memo else { return }
        delegate?.saveMemo(with: savedMemo, index: self.index)
    }
}

extension String {
    var lines: [String] { return self.components(separatedBy: NSCharacterSet.newlines)}
}
