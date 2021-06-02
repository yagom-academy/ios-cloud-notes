//
//  NoteDetail.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteDetail: UIViewController {
    lazy var textView: UITextView = {
        let textview = UITextView()
        textview.allowsEditingTextAttributes = true
        textview.textAlignment = .justified
        textview.autocapitalizationType = .sentences
        textview.showsVerticalScrollIndicator = false
        textview.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        textview.font = UIFont.preferredFont(forTextStyle: .headline)

        return textview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaaaa")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(symbol))
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textView.contentOffset = .zero
        textView.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.isEditable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textView.isEditable = false
    }
    
    @objc private func symbol() {
        
    }

    private func setConstraint() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

