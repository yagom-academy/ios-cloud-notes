//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

class SecondaryViewController: UIViewController {
    var textView = UITextView()
    let textViewDelegate = TextViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textView)
        self.textView.delegate = textViewDelegate
        setTextViewStyle()
        setSecondaryVCNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewWillLayoutSubviews() {
        textView.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    deinit {
        print(#function)
    }
    
}

extension SecondaryViewController {
    private func setTextViewStyle() {
        textView.textAlignment = .natural
        textView.adjustsFontForContentSizeCategory = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func setSecondaryVCNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "ellipsis.circle"))
    }
}
//뷰컨의 소멸시점에! viewWillDissapear
