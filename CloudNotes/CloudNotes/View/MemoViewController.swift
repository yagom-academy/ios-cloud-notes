//
//  MemoScrollViewController.swift
//  CloudNotes
//
//  Created by Ellen on 2021/09/03.
//

import UIKit

class MemoViewController: UIViewController {
    
    var textView: UITextView!
    
    override func viewDidLoad() {
        textView = UITextView()
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
