//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

class DetailViewController: UIViewController {
    var splitView: SplitViewController?
    
    let textView = UITextView()
    
    func configureTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    }
    
//    public func loadData(_ dic:NSDictionary) {
//          self.title = dic["name"] as? String ?? "상세화면"
//          self.detailText.text = dic["date"] as? String ?? "상세화면 입니다."
//
//      }
    
    public func loadData(data: [CloudNoteItem], indexPath: IndexPath) {
        self.textView.text = data[indexPath.row].body
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
}
