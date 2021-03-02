//
//  AddMemoViewController.swift
//  CloudNotes
//
//  Created by sole on 2021/02/16.
//

import UIKit

final class AddViewController: UIViewController {
    
    var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setNavigation()
    }
    
    private func setNavigation() {
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapOKButton))
    }
    
    @objc private func didTapOKButton() {
        
    }

    private func setTextView() {
        addSubview()
        setAutoLayout()
    }

    private func addSubview() {
        view.addSubview(memoTextView)
    }

    private func setAutoLayout() {
        let magin: CGFloat = 10
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: magin),
            memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: magin),
            memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -magin),
            memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -magin)
        ])
    }
}
