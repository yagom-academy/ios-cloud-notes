//
//  DetailMemoVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class DetailMemoViewController: UIViewController, UITextViewDelegate {
    static let identifier: String = "DetailMemoVC"
    private var textView = UITextView()
    private var naviButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTextViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        textView.contentOffset = .zero
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(textView)
        textView.delegate = self
        
        self.navigationItem.rightBarButtonItem = naviButton
    }
    
    private func configureTextViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }

    func configureDetailText(data: Memo) {
        let text = data.title + "\n\n\n" + data.body
        textView.text = text
    }
    
}
