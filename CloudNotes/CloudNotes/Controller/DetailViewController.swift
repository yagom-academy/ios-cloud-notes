//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class DetailViewController: UIViewController, SendDataDelegate, UIPopoverPresentationControllerDelegate {
    
    var memoDetailTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.black
        view.text = "내용을 입력하세요"
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return view
    }()
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoDetailTextView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(editMemo))
        self.view.addSubview(memoDetailTextView)
        setTextViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundColor()
    }
    
    @objc func editMemo() {
        detailActionSheet(self.navigationItem.rightBarButtonItem!)
    }
    
    func sendData(data: Memo, index: Int) {
        self.memoDetailTextView.text = "\(data.title!)\n\n" + "\(data.body!)"
        self.currentIndex = index
    }
    
    func isRegularTextViewColor(regular: Bool) {
        if regular {
            self.memoDetailTextView.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
        }
    }
    
    private func setBackgroundColor() {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            self.memoDetailTextView.backgroundColor = UIColor.lightGray
            self.view.backgroundColor = UIColor.lightGray
        }
        else {
            self.memoDetailTextView.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
        }
    }
    
    private func setTextViewConstraint() {
        self.memoDetailTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.memoDetailTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.memoDetailTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.memoDetailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let greeting = self.memoDetailTextView.text else { return }
        let splitText = greeting.split(separator: "\n",maxSplits: 1).map { (value) -> String in
            return String(value) }


        DataManager.shared.memoList[currentIndex].title = splitText.first!
        DataManager.shared.memoList[currentIndex].body = splitText.last!
        DataManager.shared.saveContext()
        DataManager.shared.fetchData()
    }
    
}

extension DetailViewController {
    
    func deleteAlert() {
        let defaultAction = UIAlertAction(title: "삭제",
                                          style: .destructive) { (action) in
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel) { (action) in
        }
        
        let alert = UIAlertController(title: "진짜요?",
              message: "정말로 삭제하시겠어요?",
              preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func detailActionSheet(_ sender: UIBarButtonItem) {
        let destroyAction = UIAlertAction(title: "Delete",
                  style: .destructive) { (action) in
            self.deleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                  style: .cancel) { (action) in
        }
        let shareAction = UIAlertAction(title: "Share..",
                    style: .default) { (action) in
            self.presentShareSheet(sender)
        }
             
        let alert = UIAlertController(title: nil,
                    message: nil,
                    preferredStyle: .actionSheet)
        alert.addAction(shareAction)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        
        if let popOverController = alert.popoverPresentationController { popOverController.barButtonItem = sender }
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func presentShareSheet(_ sender: UIBarButtonItem) {
        guard let sendText = self.memoDetailTextView.text else { return }
        
        let shareSheetViewController = UIActivityViewController(activityItems: [sendText], applicationActivities: nil)
    
        if let popOverController = shareSheetViewController.popoverPresentationController { popOverController.barButtonItem = sender }
        
        present(shareSheetViewController, animated: true, completion: nil)
    }
    
}
