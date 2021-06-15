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
    
    func setRegular(first: String, last: String) {
        let font = UIFont.italicSystemFont(ofSize: 10)
        let font2 = UIFont.boldSystemFont(ofSize: 20)
        let fullText = memoDetailTextView.text!
        

        let attributedString = NSMutableAttributedString(string: fullText)
        
        let range = (fullText as NSString).range(of: first)
        attributedString.addAttribute(.font, value: font2, range: range)
        
        if first != last {
            let range2 = (fullText as NSString).range(of: last)
            attributedString.addAttribute(.font, value: font, range: range2)
        }

        memoDetailTextView.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundColor()
    }
    
    @objc func editMemo() {
        guard let editButton = self.navigationItem.rightBarButtonItem else { return }
        detailActionSheet(editButton)
    }
    
    func sendData(data: Memo, index: Int) {
        if data.title == "새로운 메모" && data.body == "추가 텍스트 없음" {
            data.title = ""
            data.body = ""
        }
        self.memoDetailTextView.text = "\(data.title!)\n" + "\(data.body!)"
        self.currentIndex = index
        if data.title != "" && data.body != "" {
            setRegular(first: data.title!, last: data.body!)
        }
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
        
        NotificationCenter.default.post(name: NSNotification.Name("didRecieveNotification"), object: nil, userInfo: ["textViewText": greeting, "currentIndex": currentIndex] )
    }
    
}

extension DetailViewController {
    
    func deleteAlert() {
        let defaultAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            DataManager.shared.deleteData(index: self.currentIndex)
            NotificationCenter.default.post(name: NSNotification.Name("didRecieveNotification"), object: nil, userInfo: nil )
            if self.splitViewController?.traitCollection.horizontalSizeClass == .compact {
                self.splitViewController?.show(.primary)
            }
            else {
                self.sendData(data: DataManager.shared.memoList[self.currentIndex], index: self.currentIndex)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func detailActionSheet(_ sender: UIBarButtonItem) {
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let shareAction = UIAlertAction(title: "Share..", style: .default) { (action) in
            self.presentShareSheet(sender)
        }
             
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(shareAction)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        
        if let popOverController = alert.popoverPresentationController { popOverController.barButtonItem = sender }
        
        self.present(alert, animated: true)
    }
    
    func presentShareSheet(_ sender: UIBarButtonItem) {
        guard let sendText = self.memoDetailTextView.text else { return }
        
        let shareSheetViewController = UIActivityViewController(activityItems: [sendText], applicationActivities: nil)
    
        if let popOverController = shareSheetViewController.popoverPresentationController { popOverController.barButtonItem = sender }
        
        present(shareSheetViewController, animated: true)
    }
    
}
