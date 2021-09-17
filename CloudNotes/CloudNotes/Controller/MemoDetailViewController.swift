//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let memoDeatailTextView = UITextView()
    private var currentMemo: Memo?
    private let linebreak = "\n"
    private let firstIndex = 1
    private var workItem: DispatchWorkItem?
    var delegate: MemoEntitySendable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memoDeatailTextView)
        configureTextView()
        setLayoutForTextView()
        memoDeatailTextView.delegate = self
        makeNavigationItem()
    }
    
    func makeNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(touchUpShareOrDeleteButton))
    }
    
    @objc func touchUpShareOrDeleteButton() {
        let shareAction = UIAlertAction(title: "Share..", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showRemoveAlert()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        
        UIAlertController.showAlert(title: nil, message: nil, preferredStyle: .actionSheet, actions: [shareAction, deleteAction, cancelAction], animated: true, viewController: self)
    }
    
    private func showRemoveAlert() {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        UIAlertController.showAlert(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert, actions: [deleteAction, cancelAction], animated: true, viewController: self)
    }
    
    func configureTextView(by memo: MemoEntity) {
        if let title = memo.title, let body = memo.body {
            memoDeatailTextView.text = title + linebreak + body
        } else {
            memoDeatailTextView.text = PlaceHolder.title + linebreak + PlaceHolder.body
        }
        CoreDataManager.shared.fetchMemo()
    }
    
    private func configureTextView() {
        memoDeatailTextView.translatesAutoresizingMaskIntoConstraints = false
        memoDeatailTextView.autocorrectionType = .no
        memoDeatailTextView.backgroundColor = .secondarySystemBackground
        memoDeatailTextView.textColor = .secondaryLabel
    }
    
    private func setLayoutForTextView() {
        NSLayoutConstraint.activate([memoDeatailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     memoDeatailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     memoDeatailTextView.topAnchor.constraint(equalTo: view.topAnchor),
                                     memoDeatailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func configureDebounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let validWorkItem = workItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: validWorkItem)
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        configureDebounce { [self] in
            let lastIndex = Int(textView.text.components(separatedBy: linebreak).count - firstIndex)
            let title = textView.text.components(separatedBy: linebreak)[.zero]
            let body = textView.text.components(separatedBy: linebreak)[firstIndex...lastIndex].joined(separator: linebreak)
            let now = Date()
            
            if lastIndex > firstIndex {
                let currentEntity = CoreDataManager.shared.createMemo(title: title, body: body, lastModifiedDate: now)
                delegate?.textViewModify(at: currentEntity)
            } else {
                let currentEntity = CoreDataManager.shared.createMemo(title: title, body: PlaceHolder.body, lastModifiedDate: now)
                delegate?.textViewModify(at: currentEntity)
            }
        }
    }
}
