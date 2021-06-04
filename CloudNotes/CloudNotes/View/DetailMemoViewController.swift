//
//  DetailMemoVC.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class DetailMemoViewController: UIViewController, UITextViewDelegate {
    static let identifier: String = "DetailMemoVC"
    var splitView: SplitViewController?
    
    private var textView = UITextView()
    private var naviButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTextViewConstraints()
        addSizeCondition()
        
    }
    
    private func configureView() {
        view.backgroundColor = .white
        textView.delegate = self
        textView.contentOffset = .zero
        self.navigationItem.rightBarButtonItem = naviButton
    }
    
    private func configureTextViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }
    
    func addSizeCondition() {
        if UITraitCollection.current.horizontalSizeClass == .regular {
            guard let root = self.splitView?.root as? MemoListViewController else { return }
            root.memoModel.loadSampleData()
            self.configureDetailText(data: root.memoModel.readMemo(index: 0))
        }
    }
    
    func configureDetailText(data: Memo) {
        let text = data.title + "\n\n\n" + data.body
        textView.text = text
    }
    
}
