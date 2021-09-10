//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

class SecondaryViewController: UIViewController {
    var textView = UITextView()
    var holder: TableViewIdexPathHolder?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textView)
        self.textView.delegate = self
        setTextViewStyle()
        setSecondaryVCNavigationBar()
    }
    
    func configure(_ holder: TableViewIdexPathHolder) {
        textView.text = holder.textViewText
    }
    
    override func viewWillLayoutSubviews() {
        textView.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}

extension SecondaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        MemoData.list?[holder?.indexPath?.row ?? .zero ].lastModified = myInt
        holder?.tableView?.reloadData()
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
