//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//
import UIKit

class ContentViewController: UIViewController {
    // MARK: - Property
    private var contentTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.returnKeyType = .done
        if UITraitCollection.current.userInterfaceIdiom == .phone {
            textView.font = .systemFont(ofSize: 20, weight: .bold)
        } else {
            textView.font = .systemFont(ofSize: 25, weight: .bold)
        }
        return textView
    }()
    var memo: String?
    var memoEntity: MemoEntity?
    var originalMemoContent: String?

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let memo = memo {
            contentTextView.text = memo
        } else if let memoEntity = memoEntity {
            contentTextView.text = memoEntity.content
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureNavigationBar()
        configureTextView()
        scrollWhenContentTextViewDidAppear()
        scrollWhenKeyboardWillAppear()
        setMemoIfNewMemoOrOriginalMemo()

        setMemoListTableViewDelegate()
        contentTextView.delegate = self

    }

}

// MARK: - Method
extension ContentViewController {
    func showAlertContainTwoAction(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let memo = self.memoEntity {
                DataManager.shared.deleteMemo(memo)
                NotificationCenter.default.post(name: Self.memoDidDelete, object: nil)
               // 여기
                (self.splitViewController?.viewControllers.last as? UINavigationController)?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addActions([cancelAction, deleteAction])
        present(alert, animated: true, completion: nil)
    }

    private func setMemoListTableViewDelegate() {
        if let navigationController = splitViewController?.viewControllers.first,
           let memoListTableViewController = navigationController.children.first as? MemoListTableViewController {
            memoListTableViewController.delegate = self
        }
    }

    private func setMemoIfNewMemoOrOriginalMemo() {
        if let memoEntity = memoEntity {
            contentTextView.text = memoEntity.content
            originalMemoContent = memoEntity.content
        } else {
            contentTextView.text = ""
        }
    }

    private func configureTextView() {
        view.addSubview(contentTextView)
        contentTextView.setConstraintEqualToAnchor(superView: view)

    }

    private func configureNavigationBar() {
        let itemImage = UIImage(systemName: "ellipsis.circle")
        let rightBarButtonItem = UIBarButtonItem(image: itemImage, style: .plain, target: self, action: #selector(showSheetMoreDetail))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }

    private func createMoreDetailSheet() -> UIAlertController {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
//            guard let memo = self?.memoEntity?.content else { return }
            let activityViewController = UIActivityViewController(activityItems: ["Test"], applicationActivities: nil)
            self?.present(activityViewController, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in

            self?.showAlertContainTwoAction(title: "진짜요?", message: "정말로 삭제하시겠어요?")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addActions([shareAction, deleteAction, cancelAction])
        return sheet
    }

    @objc private func showSheetMoreDetail() {
        let sheet = createMoreDetailSheet()
        present(sheet, animated: true, completion: nil)
    }

    private func scrollWhenContentTextViewDidAppear() {
        contentTextView.scrollsToTop = true
        let contentTextViewHeight = contentTextView.contentSize.height
        let contentTextViewOffSet = contentTextView.contentOffset.x
        let contentOffSet = contentTextViewHeight - contentTextViewOffSet
        contentTextView.contentOffset = CGPoint(x: 0, y: -contentOffSet)
    }

    private func scrollWhenKeyboardWillAppear() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let height = rect.height
                var contentInset = self.contentTextView.contentInset
                contentInset.bottom = height
                self.contentTextView.contentInset = contentInset

                contentInset = self.contentTextView.verticalScrollIndicatorInsets
                contentInset.bottom = height
                self.contentTextView.verticalScrollIndicatorInsets = contentInset
            }
        }
    }
}

extension ContentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            guard let memo = textView.text, memo.count > 0 else {
                showAlert(message: "메모를 입력하세요.")
                return false
            }
            if let memoEntity = memoEntity {
                memoEntity.content = memo
                DataManager.shared.saveContext()
                NotificationCenter.default.post(name: Self.memoDidUpdate, object: nil)
            } else {
                let title = String(memo.prefix(20))
                DataManager.shared.addNewMemo(memo, title)
                NotificationCenter.default.post(name: Self.newMemoDidInput, object: nil)
            }
            textView.resignFirstResponder()
            showAlert(message: "메모가 저장됐습니다.")
            return false
        }
        return true
    }
}

// MARK: - CustomDelegate Conform
extension ContentViewController: MemoListTableViewControllerDelegate {
    func didTapMemo(_ vc: UITableViewController, memo: String) {
        contentTextView.text = memo
    }
}

extension ContentViewController {
    static let newMemoDidInput = Notification.Name("newMemoDidInput")
    static let memoDidUpdate = Notification.Name("memoDidUpdate")
    static let memoDidDelete = Notification.Name("memoDidDelete")
}
