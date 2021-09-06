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
            updateMemo()
        }
    }
    
    private var titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.font = UIFont.preferredFont(forTextStyle: .title2)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.isScrollEnabled = false
        return titleTextView
    }()
    
    private var bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.font = UIFont.systemFont(ofSize: 15)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        return bodyTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        bodyTextView.delegate = self
        view.backgroundColor = .white
        addSubView()
        updateMemo()
        ConfigureAutoLayout()
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func updateMemo() {
        titleTextView.text = memo?.title
        bodyTextView.text = memo?.body
    }
    
    private func addSubView() {
        view.addSubview(titleTextView)
        view.addSubview(bodyTextView)
    }
    
    private func ConfigureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant:
            margin),
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin)
        ])
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let newMemo = Memo(title: titleTextView.text, body: bodyTextView.text, date: Date().timeIntervalSince1970)
        
        memo = newMemo
        
        guard let savedMemo = memo else { return }
        delegate?.saveMemo(with: savedMemo, index: self.index)
    }
}
