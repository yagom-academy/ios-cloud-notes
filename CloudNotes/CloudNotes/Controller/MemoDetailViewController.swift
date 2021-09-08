//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let lineBreak = "\n"
    private let memoTextView = UITextView()
    private var memoItem: Memo? {
        didSet {
            guard let memoItem = memoItem else {
                memoTextView.text = nil
                return
            }
            let mergedContents = merge(contents: memoItem.title, memoItem.body)
            memoTextView.text = mergedContents
        }
    }
    weak var memoModifyingDelegate: MemoChangeHandleable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemoTextViewConstraints()
        setUpNavigationItem()
        memoTextView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        if traitCollection.horizontalSizeClass == .compact {
            memoTextView.backgroundColor = .systemGray
        } else {
            memoTextView.backgroundColor = .white
        }
    }

}

//MARK:- Set up memoTextView
extension MemoDetailViewController {
    private func setUpMemoTextViewConstraints() {
        view.addSubview(memoTextView)
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        
        memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    func configure(with memoItem: Memo?) {
        self.memoItem = memoItem
    }
    
    private func merge(contents: String...) -> String {
        return contents.joined(separator: lineBreak + lineBreak)
    }
}

//MARK:- Set up NavigationBar
extension MemoDetailViewController {
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
}

//MARK:- Conforms to TextViewDelegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var itemContents = textView.text.components(separatedBy: lineBreak + lineBreak)
        let title = itemContents.removeFirst()
        let body = itemContents.joined(separator: lineBreak + lineBreak)
        let revisedMemo = Memo(title: title, body: body, lastModified: Date().timeIntervalSince1970)
        
        memoModifyingDelegate?.processModified(data: revisedMemo)
    }
}
