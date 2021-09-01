//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class DetailMemoViewController: UIViewController {

    var memo: Memo?
    
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
        view.backgroundColor = .white
        addSubView()
        setMemo()
        ConfigureAutoLayout()
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
            titleTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant:
            margin),
            bodyTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin)
        ])
    }
}
