//
//  DetailTextViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import UIKit

class DetailTextViewController: UIViewController {
    var memo: Savable?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = memo?.body
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(textView)
        setTextViewAnchor()
    }
    
    private func setTextViewAnchor() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
            .isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
            .isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
            .isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            .isActive = true
    }
    
    func configure(with memo: Savable) {
        self.memo = memo
    }
}
