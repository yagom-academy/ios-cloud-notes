//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var memoTextView = UITextView()
    var memoMain = UITextView()
    var indexPath: IndexPath?
    
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        memoTextView.delegate = self
        memoTextView.contentInsetAdjustmentBehavior = .automatic
        memoTextView.textAlignment = NSTextAlignment.justified
        memoTextView.contentOffset = CGPoint(x: 0,y: 0)
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.view.addSubview(memoTextView)
        setUpMemoTextView()
    }
        
    private func setUpMemoTextView() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.memoTextView.translatesAutoresizingMaskIntoConstraints = false
        self.memoTextView.font = self.memoTextView.font?.withSize(20)
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            self.memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
        ])
    }

    func configure(with memo: Memo) {
        memoTextView.text = "\n\n" + memo.computedTitle + "\n\n" + memo.computedBody
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let indexPath = self.indexPath else {
            return
        }
        var text = textView.text.components(separatedBy: "\n")
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedTitle = text.remove(at: 0)
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedBody = text.joined()
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedlastModifiedDate = Int(Date().timeIntervalSince1970)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
//    func setUpTextView() {
//        if descriptions.text == "제품 상세 설명" {
//            descriptions.text = ""
//            descriptions.textColor = UIColor.black
//        } else if descriptions.text == "" {
//            descriptions.text = "제품 상세 설명"
//            descriptions.textColor = UIColor.systemGray4
//        }
//    }
    
}
