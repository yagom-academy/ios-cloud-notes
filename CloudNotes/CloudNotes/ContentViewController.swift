//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    lazy var titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.font = .preferredFont(forTextStyle: .headline)
        titleTextView.adjustsFontForContentSizeCategory = true
        return titleTextView
    }()
    lazy var bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.font = .preferredFont(forTextStyle: .body)
        bodyTextView.adjustsFontForContentSizeCategory = true
        return bodyTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpContentView()
    }
    
    private func setUpContentView() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleTextView)
        self.view.addSubview(bodyTextView)
        
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        setUpConstraints()
        
        textViewDidChange(titleTextView)
        textViewDidChange(bodyTextView)
    }
    
    private func setUpConstraints() {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            bodyTextView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            bodyTextView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        titleTextView.isScrollEnabled = false
        bodyTextView.isScrollEnabled = false
    }

    private func updateUI(with memo: Memo) {
        titleTextView.text = memo.title
        bodyTextView.text = memo.body
    }
}
extension ContentViewController: ListViewControllerDelegate {
    func didTapMemoItem(title: String, body: String) {
        self.titleTextView.text = title
        self.bodyTextView.text = body
    }
    
}
extension ContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let rearrangedSize = textView.sizeThatFits(size)
       
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = rearrangedSize.height
            }
        }
    }
}
