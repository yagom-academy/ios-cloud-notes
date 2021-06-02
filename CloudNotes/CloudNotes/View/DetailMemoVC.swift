//
//  DetailMemoVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class DetailMemoVC: UIViewController, UITextViewDelegate {
    static let identifier: String = "DetailMemoVC"
    var splitView: SplitVC?
    var textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTextView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        textView.delegate = self
    }
    
    func configureTextView() {
        let margins = view.safeAreaLayoutGuide
        
        view.addSubview(textView)
        
        guard let root = self.splitView?.root as? MemoListVC else { return }
        root.memoModel.loadSampleData()
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.configureDetail(data: root.memoModel.readMemo(index: 0)) 
        textView.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: margins.heightAnchor),
        ])
    }
    
    func configureDetail(data: Memo) {
        let text = data.title + "\n" + data.body
        textView.text = text
    }
    
    
}
