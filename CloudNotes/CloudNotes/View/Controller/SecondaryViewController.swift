//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit
import CoreData

enum ActionSheetMenu {
    case delete
    case share
    case cancle
    
    var literal: String {
        switch self {
        case .delete:
            return "Delete"
        case .share:
            return "Share..."
        case .cancle:
            return "Cancle"
        }
    }
}

final class SecondaryViewController: UIViewController, CoreDataUsable {
    private var textView = UITextView()
    private let context = MemoDataManager.context
    private var holder: TextViewRelatedDataHolder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(textView)
        self.textView.delegate = self
        self.setTextViewStyle()
        self.setSecondaryVCNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        self.textView.setPosition(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}

extension SecondaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let todayDateData = Int(timeInterval)
        
        let lineBreaker = "\n"
        let bodyStartIndex = 1
        
        let currentMemo = textView.text.components(separatedBy: lineBreaker)
        let currentMemoTitle = currentMemo.first
        let currentMemoBodyArray = currentMemo[bodyStartIndex...]
        var currentMemoBody = currentMemoBodyArray.reduce("") { $0 + lineBreaker + $1 }
        let currentMemoData = MemoDataManager.memos[holder?.indexPath?.row ?? .zero]
        
        if !currentMemoBody.isEmpty {
            currentMemoBody.removeFirst()
        }
        
        do {
            currentMemoData.title = currentMemoTitle
            currentMemoData.body = currentMemoBody
            currentMemoData.lastModifiedDate = Int64(todayDateData)
            try self.context.save()
        } catch {
            print(CoreDataError.saveError.errorDescription)
        }
        
        self.fetchCoreDataItems(context, holder?.tableView ?? UITableView())
    }
}

extension SecondaryViewController {
    func configure(_ holder: TextViewRelatedDataHolder) {
        self.holder = holder
        updateTextViewText()
    }
    
    private func updateTextViewText() {
        self.textView.text = self.holder?.textViewText
    }
    
    private func setTextViewStyle() {
        self.textView.textAlignment = .natural
        self.textView.adjustsFontForContentSizeCategory = true
        self.textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func setSecondaryVCNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapSeeMoreButton))
    }
    
    //MARK:-NavigationBar Item relate method
    @objc func didTapSeeMoreButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteActions = UIAlertAction(title: ActionSheetMenu.delete.literal, style: .destructive, handler: { action in
            // 삭제 관리하는 타입이 있어야하나?
            
        })
        let shareAction = UIAlertAction(title: ActionSheetMenu.share.literal, style: .default, handler: { action in
            print("공유")
        })
        
        let cancleAction = UIAlertAction(title: ActionSheetMenu.cancle.literal, style: .cancel, handler: { action in
            print("취소")
        })
        
        alert.addAction(shareAction)
        alert.addAction(deleteActions)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
}
