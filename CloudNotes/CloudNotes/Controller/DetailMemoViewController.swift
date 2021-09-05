//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    weak var delegate: Memorizable?
    var index = IndexPath()

    var memo: Memo? {
        didSet {
            setMemo()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        bodyTextView.delegate = self
        view.backgroundColor = .white
        addSubView()
        setMemo()
        ConfigureAutoLayout()
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func setMemo() {
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
        memo?.title = titleTextView.text
        memo?.body = bodyTextView.text
        memo?.date = 1234
        
        guard let savedMemo = memo else { return }
        delegate?.saveMemo(with: savedMemo, index: self.index)
    }
}
