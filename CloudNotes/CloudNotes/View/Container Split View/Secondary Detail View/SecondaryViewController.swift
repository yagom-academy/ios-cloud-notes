//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class SecondaryViewController: UIViewController {
    private let secondaryView = SecondaryView()
    private var currentMemeIndexPath: IndexPath?
    private let rootDelegate: SplitViewController
    private let twiceLineBreaks = "\n\n"
    private let hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: nil,
                                                    action: #selector(resignFromTextView))
    private let seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                      style: .plain,
                                                      target: nil,
                                                      action: #selector(tappingSeeMoreButton))

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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

        // 3. 컨트롤러를 닫은 후 실행할 완료 핸들러 지정
        activity.completionWithItemsHandler = { (_, isComplete, _, _) in
            if isComplete {
            // 성공했을 때 작업
                NSLog("성공")
           } else {
            // 실패했을 때 작업
                NSLog("실패")
           }
        }
        // 4. 컨트롤러 나타내기(iPad에서는 팝 오버로, iPhone과 iPod에서는 모달로 나타냅니다.)
        self.present(activity, animated: true, completion: nil)
    }

    func selectedDelete(action: UIAlertAction) {
        let alert = UIAlertController(title: Strings.Alert.deleteTitle.description,
                                      message: Strings.Alert.deleteMessage.description,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Alert.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: Strings.Alert.delete.description, style: .destructive) { _ in
            guard let currentIndex = self.currentMemeIndexPath else {
                print("에러처리 필요 - SecondaryViewController.deleteMemo : 현재 선택된 메모 인덱스 데이터 없음")
                return
            }
            self.rootDelegate.deleteMemo(at: currentIndex, completion: { _ in })
        })
        self.present(alert, animated: true)
    }
}

extension SecondaryViewController {
//    func updateMemo(by editedText: String) {
//        var split = editedText.split(whereSeparator: \.isNewline)
//        let title = String(split.removeFirst())
//        let body = split.joined(separator: twiceLineBreaks)
//        let nowDate = Date().timeIntervalSince1970
//
//        let updatedMemo = Memo(title: title, body: body, lastModified: nowDate)
//    }
    
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
