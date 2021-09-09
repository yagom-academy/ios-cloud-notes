//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

class DetailViewController: UIViewController {
    var splitView: SplitViewController?
    var indexPath: IndexPath?
    
    let textView = UITextView()
    lazy var text = textView.text {
        didSet {
            guard let menu = splitView?.menu as? MenuViewController else {
                return
            }
            menu.loadData(detail: text!, indexPath: indexPath!)
        }
    }
    
    func configureTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    }
    
    func loadData(data: [CloudNoteItem], indexPath: IndexPath) {
        self.textView.text = data[indexPath.row].body
        self.indexPath = indexPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
}
