//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit
import CoreData

class SecondaryViewController: UIViewController, CoreDataUsable {
    private var textView = UITextView()
    private let context = MemoDataManager.context
    
    var holder: TextViewRelatedDataHolder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(textView)
        self.textView.delegate = self
        self.setTextViewStyle()
        self.setSecondaryVCNavigationBar()
    }

    override func viewWillLayoutSubviews() {
        self.textView.setPosition(top: view.safeAreaLayoutGuide.topAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}

extension SecondaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        let currentMemo = MemoDataManager.memos[holder?.indexPath?.row ?? .zero]
        do {
            currentMemo.title = textView.text
            currentMemo.lastModifiedDate = Int64(myInt)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "ellipsis.circle"))
    }
}
