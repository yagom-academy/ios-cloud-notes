//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

protocol SecondaryDetailViewDelegate: NSObject {
    func reloadPrimaryTableView()
    func showPrimaryTableView()
}

class SecondaryViewController: UIViewController {
    private let secondaryView = SecondaryView()
    
    private lazy var hidableDoneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: self,
                                                    action: #selector(resignFromTextView))
    private lazy var seeMoreStaticButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(tappingSeeMoreButton))
    weak var rootDelegate: SecondaryDetailViewDelegate?
//    private let coreManager = MemoCoreDataManager.shared
    private var currentMemeIndexPath: IndexPath?
    private var checkChanging: String?
    private let coreManager: MemoCoreDataManager
    
    init(coreManager: MemoCoreDataManager) {
        self.coreManager = coreManager
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
        guard let willUpdateMemo = decideDeletingMemo(by: textView.text) else { // 해당 메모 삭제됨
            return
        }
        guard checkChanging != textView.text else { // 데이터 변화 없음
            return
        }
        decideSavingMemo(data: willUpdateMemo)   // 데이터 변화 CoreData Update
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
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.share.description, style: .default, handler: selectedSharing))
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.delete.description, style: .destructive, handler: selectedDeleting))
        sheet.addAction(UIAlertAction(title: Strings.ActionSheet.cancel.description, style: .cancel))
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let presenter = sheet.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY + 20, width: 0, height: 0)
                presenter.permittedArrowDirections = [.any]
                self.present(sheet, animated: true, completion: nil)
            }
        } else {
          self.present(sheet, animated: true, completion: nil)
        }
    }
    
    func selectedSharing(action: UIAlertAction) {
        guard let currentMemo = decideDeletingMemo(by: secondaryView.textView.text) else { // 공유할 데이터 없음
            rootDelegate?.showPrimaryTableView()
            return
        }
        let activity = UIActivityViewController(activityItems: [currentMemo.title, currentMemo.body, currentMemo.lastModified], applicationActivities: nil)
        activity.excludedActivityTypes = [.assignToContact, .postToVimeo, .saveToCameraRoll]
        activity.completionWithItemsHandler = { (_, isComplete, _, _) in
            if isComplete {
                NSLog("Sharing 성공")
           } else {
                NSLog("Sharing 실패")
           }
        }
        self.present(activity, animated: true, completion: nil)
    }

    func selectedDeleting(action: UIAlertAction) {
        let alert = UIAlertController(title: Strings.Alert.deleteTitle.description,
                                      message: Strings.Alert.deleteMessage.description,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Alert.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: Strings.Alert.delete.description, style: .destructive) { _ in
            guard let indexPath = self.currentMemeIndexPath,
                  let objectID = self.coreManager[indexPath.row].objectID else {
                NSLog("에러처리 필요 - SecondaryViewController.deleteMemo : 현재 선택된 메모 인덱스 데이터 없음")
                return
            }
            self.coreManager.deleteData(at: objectID) {
                self.rootDelegate?.reloadPrimaryTableView()
                self.drawDetailView(at: self.currentMemeIndexPath.flatMap {
                    return $0.row < self.coreManager.listCount ? $0 : nil
                })
            }
        })
        self.present(alert, animated: true)
    }
}

extension SecondaryViewController {
    func drawDetailView(at indexPath: IndexPath?) {
        if let index = indexPath?.row {
            let seletedMemo = coreManager[index]
            let text = seletedMemo.title + Strings.KeyboardInput.twiceLineBreaks.rawValue + seletedMemo.body
            secondaryView.configure(by: text)
        } else {
            secondaryView.configure(by: nil)
        }
        currentMemeIndexPath = indexPath
    }
    
    func decideDeletingMemo(by editedText: String) -> MemoData? {
        guard let index = currentMemeIndexPath?.row,
              let objectID = coreManager[index].objectID else {
            NSLog("에러처리 필요 - SecondaryViewController.decideDeletingProcess : 현재 메모 인덱스 없음")
            return nil
        }
        var split = editedText.split(whereSeparator: \.isNewline)
        let nowDate = Date().timeIntervalSince1970
        if editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            coreManager.deleteData(at: objectID) {
                self.rootDelegate?.reloadPrimaryTableView()
                self.drawDetailView(at: self.currentMemeIndexPath.flatMap {
                    return $0.row < self.coreManager.listCount ? $0 : nil
                })
            }
            return nil
        } else {
            let title = String(split.removeFirst())
            let body = split.joined(separator: Strings.KeyboardInput.twiceLineBreaks.rawValue)
            return MemoData(title, body, nowDate, objectID)
        }
    }

    func decideSavingMemo(data: MemoData?) {
        guard let memo = data else {
            NSLog("에러처리 필요 - SecondaryViewController.decideSavingProcess : 업데이트 할 메모가 없음")
            return
        }
        coreManager.editData(by: memo) {
            self.rootDelegate?.reloadPrimaryTableView()
        }
    }
}
