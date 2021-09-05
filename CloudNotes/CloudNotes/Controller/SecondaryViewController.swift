//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

class SecondaryViewController: UIViewController {
    var textView: UITextView!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView = UITextView()
        view.addSubview(textView)
        textView.setPosition(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        textView.frame = view.bounds
        textView.text = text
    }
}
