//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let memoTextView = UITextView()
    private var memoItem: Memo?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemoTextViewConstraints()
        setUpMemoContents()
    }

}

//MARK:- Set up memoTextView
extension MemoDetailViewController {
    private func setUpMemoTextViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func setUpMemoContents() {
        guard let memoItem = memoItem else {
            return
        }
        let mergedContents = merge(contents: memoItem.title, memoItem.body)
        memoTextView.text = mergedContents
    }
    
    private func merge(contents: String...) -> String {
        let emptyString = ""
        let lineBreak = "\n"
        return contents.reduce(emptyString) { $0 + lineBreak + lineBreak + $1 }
    }
}
