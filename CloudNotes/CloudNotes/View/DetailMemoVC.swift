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
    private var textView = UITextView()
    
    private var naviButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTextViewConstraints()
        forRegularPlaceHolder()
        
    }
    
    override func viewDidLayoutSubviews() {
        textView.contentOffset = .zero
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        textView.delegate = self
        self.navigationItem.rightBarButtonItem = naviButton
    }
    
    private func configureTextViewConstraints() {
        let margins = view.safeAreaLayoutGuide
        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: margins.heightAnchor),
        ])
    }
    
    func forRegularPlaceHolder() {
        if UITraitCollection.current.horizontalSizeClass == .regular {
            guard let root = self.splitView?.root as? MemoListVC else { return }
            root.memoModel.loadSampleData()
            self.configureDetail(data: root.memoModel.readMemo(index: 0))
        }
    }
    
    func configureDetail(data: Memo) {
        let text = data.title + "\n" + data.body
        textView.text = text
    }
    
    
}
