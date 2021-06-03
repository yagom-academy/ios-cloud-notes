//
//  NoteDetail.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteDetail: UIViewController {
    var noteData: NoteData? {
        didSet {
            guard let data = noteData else { return }
            textView.text = ""
            textView.insertText(data.title ?? "")
            textView.insertText("\n\n")
            textView.insertText(data.description ?? "")
        }
    }
    lazy var textView: UITextView = {
        let textview = UITextView()
        textview.allowsEditingTextAttributes = true
        textview.showsVerticalScrollIndicator = false
        textview.textAlignment = .justified
        textview.autocapitalizationType = .sentences
        textview.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        textview.font = UIFont.preferredFont(forTextStyle: .headline)

        return textview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(displayInfomation))
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
    
    @objc private func displayInfomation() {
        // TODO: - Detail 정보 보여주기
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
