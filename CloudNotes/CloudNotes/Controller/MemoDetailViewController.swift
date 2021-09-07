//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemoTextViewConstraints()
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
        let lineBreak = "\n"
        return contents.joined(separator: lineBreak + lineBreak)
    }
}
