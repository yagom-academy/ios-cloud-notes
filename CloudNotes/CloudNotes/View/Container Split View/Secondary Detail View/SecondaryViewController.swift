//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    private let secondaryView = SecondaryView()
    private let rootDelegate: SplitViewController
    private let hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: nil,
                                                    action: #selector(resignFromTextView))
    private let seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                      style: .plain,
                                                      target: nil,
                                                      action: #selector(tappingSeeMoreButton))
    private var currentMemeIndexPath: IndexPath?
    private var checkChanging: String?
    
    init(rootDelegate: SplitViewController) {
        self.rootDelegate = rootDelegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SecondaryViewController - viewWillAppear")
        setBarButtons(isHide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SecondaryViewController - viewWillDisappear")
        resignFromTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(secondaryView)
        NSLayoutConstraint.activate([
            secondaryView.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        secondaryView.textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - TextView Delegate
extension SecondaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkChanging = textView.text
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("SecondaryViewController - textViewDidEndEditing")
        guard checkChanging != textView.text else {
            return
        }
        guard let currentText = textView.text else {
            NSLog("에러처리 필요 - textViewDidEndEditing.textViewDidEndEditing : textView.text 비어있음")
            return
        }
        let tempMemo = makeTempMemo(by: currentText)
        rootDelegate.editMemo(by: tempMemo, at: currentMemeIndexPath) {
            currentMemeIndexPath = IndexPath(row: 0, section: 0)
        }
    }
}

// MARK: - Keyboard Notification
extension SecondaryViewController {
    @objc func keyboardWasShown(_ notification: Notification) {
        setBarButtons(isHide: false)
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        setBarButtons(isHide: true)
    }
    
    @objc func resignFromTextView() {
        secondaryView.textView.resignFirstResponder()
    }
    
    func setBarButtons(isHide: Bool) {
        self.navigationItem.rightBarButtonItems = isHide ? [seeMoreStaticButton] : [hidableDoneButton, seeMoreStaticButton]
    }
}

// MARK: - Button & Alert Actions
extension SecondaryViewController {
    @objc func tappingSeeMoreButton() {
        resignFromTextView()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.share.description, style: .default, handler: selectedShare))
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.delete.description, style: .destructive, handler: selectedDelete))
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.cancel.description, style: .cancel))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func selectedShare(action: UIAlertAction) {
        // 1. UIActivityViewController 초기화, 공유 아이템 지정
        let testText: String = "여기에 제목이 나오도록 해야지"

        let activity = UIActivityViewController(activityItems: [testText], applicationActivities: nil)

        // 2. 기본으로 제공되는 서비스 중 사용하지 않을 UIActivityType 제거(선택 사항)
        activity.excludedActivityTypes = []

        activity.completionWithItemsHandler = { (_, isComplete, _, _) in
            if isComplete {
                NSLog("성공")
           } else {
                NSLog("실패")
           }
        }
        self.present(activity, animated: true, completion: nil)
    }

    func selectedDelete(action: UIAlertAction) {
        let alert = UIAlertController(title: Strings.Alert.deleteTitle.description,
                                      message: Strings.Alert.deleteMessage.description,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Alert.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: Strings.Alert.delete.description, style: .destructive) { _ in
            guard let currentIndex = self.currentMemeIndexPath else {
                NSLog("에러처리 필요 - SecondaryViewController.deleteMemo : 현재 선택된 메모 인덱스 데이터 없음")
                return
            }
            self.rootDelegate.deleteMemo(at: currentIndex, completion: { _ in })
        })
        self.present(alert, animated: true)
    }
}

extension SecondaryViewController {
    func makeTempMemo(by text: String) -> MemoData {
        var split = text.split(whereSeparator: \.isNewline)
        if split.isEmpty {
            let nowDate = Date().timeIntervalSince1970
            return MemoData("", "", nowDate, nil)
        } else {
            let title = String(split.removeFirst())
            let body = split.joined(separator: Strings.KeyboardInput.twiceLineBreaks.rawValue)
            let nowDate = Date().timeIntervalSince1970
            return MemoData(title, body, nowDate, nil)
        }
    }
    
    func updateDetailView(by memo: MemoModel, at indexPath: IndexPath) {
        let text = memo.title + Strings.KeyboardInput.twiceLineBreaks.rawValue + memo.body
        currentMemeIndexPath = indexPath
        secondaryView.configure(by: text)
    }
    
    func initDetailView() {
        currentMemeIndexPath = nil
        secondaryView.configure(by: nil)
    }
}
