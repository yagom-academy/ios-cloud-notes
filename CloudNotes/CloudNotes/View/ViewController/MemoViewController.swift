//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

final class MemoViewController: UIViewController {
  let viewModel = MemoViewModel()
  var memoInfoBeforeRevising: MemoInfo? = nil
  
  private let titleTextField: UITextField = {
    let textField = UITextField()
    // TODO: - textField.backgroundColor = UIColor.white
    textField.backgroundColor = UIColor.green
    textField.frame.size.height = 1
    
    return textField
  }()
  
  private let bodyTextView: UITextView = {
    let textView = UITextView()
    // TODO: - delete: textView.backgroundColor = UIColor.red
    textView.backgroundColor = UIColor.red
    textView.keyboardDismissMode = .onDrag
    
    return textView
  }()
  
  private let textStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    // FIXME: - stackView.distribution: 적절히 변경해야 함
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    stackView.contentMode = .scaleToFill
        
    return stackView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    guard let memoInfo = self.viewModel.memoInfo else {
      return
    }
    memoInfoBeforeRevising = memoInfo
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    
    textStackView.addArrangedSubview(titleTextField)
    textStackView.addArrangedSubview(bodyTextView)
    
    view.addSubview(textStackView)
    
    // FIXME: - Autolayout programmatically: safeAreaLayoutGuide
//    textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textStackView.frame = view.bounds
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if titleTextField.text == MemoInfo.defaultTitle
        && bodyTextView.text == MemoInfo.defaultBody {
      guard let lastModifiedDate = self.viewModel.memoInfo?.lastModified else {
        return
      }
      MemoDataManager.shared.deleteMemo(lastModifiedDate: lastModifiedDate)
    }
    
    guard let memoInfo = memoInfoBeforeRevising else {
      return
    }

    if titleTextField.text != memoInfo.title
        || bodyTextView.text != memoInfo.body {
      updateMemoView()
    }
  }
  
  private func updateMemoView() {
    guard let lastModifiedDate = viewModel.memoInfo?.lastModified else {
      return
    }
    let titleText: String = {
      var text = titleTextField.text ?? MemoInfo.defaultTitle
      if text == "" {
        text = MemoInfo.defaultTitle
      }
      
      return text
    }()
    MemoDataManager.shared.updateMemo(lastModifiedDate: lastModifiedDate,
                                      titleToReplace: titleText,
                                      bodyToReplace: bodyTextView.text)
    
    guard let listView =
            self.navigationController?.viewControllers.first as? ListViewController else {
      return
    }
    listView.updateTable()
  }
  
  func updateUI() {
    if let memoInfo = self.viewModel.memoInfo {
      titleTextField.text = memoInfo.title
      bodyTextView.text = memoInfo.body
    }
  }
  
  func configureNavigationBar() {
    let ellipsisImage = UIImage(systemName: "ellipsis.circle")
    let ellipsis = UIBarButtonItem(image: ellipsisImage,
                                   style: .plain,
                                   target: self,
                                   action: #selector(buttonPressed(_:)))
    navigationItem.rightBarButtonItem = ellipsis
  }
  
  @objc private func buttonPressed(_ sender: Any) {
    let actionSheet = UIAlertController()
    actionSheet.addAction(
      UIAlertAction(title: "Cancel",
                    style: UIAlertAction.Style.cancel,
                    handler: nil))
    actionSheet.addAction(
      UIAlertAction(title: "Share...",
                    style: UIAlertAction.Style.default,
                    handler: { _ in
                      guard let memoInfo = self.viewModel.memoInfo else {
                        return
                      }
                      let memoInfoToShare = memoInfo.convertToShare()
                      let activityViewController = UIActivityViewController(activityItems: memoInfoToShare,
                                                                            applicationActivities: nil)
                      activityViewController.popoverPresentationController?.sourceView = self.view
                      self.present(activityViewController, animated: true, completion: nil)
                    }))
    actionSheet.addAction(
      UIAlertAction(title: "Delete",
                    style: UIAlertAction.Style.destructive,
                    handler: { _ in
                      self.present(self.deleteAlert(),
                                   animated: true,
                                   completion: nil)
                    }))
    self.present(actionSheet,
                 animated: true,
                 completion: nil)
  }
  
  private func deleteAlert() -> UIAlertController {
    let alert = UIAlertController(
      title: "진짜요?",
      message: "정말로 삭제하시겠어요?",
      preferredStyle: UIAlertController.Style.alert
    )
    alert.addAction(
      UIAlertAction(title: "삭제",
                    style: UIAlertAction.Style.destructive,
                    handler: { _ in
                      guard let lastModifiedDate = self.viewModel.memoInfo?.lastModified else {
                        return
                      }
                      MemoDataManager.shared.deleteMemo(lastModifiedDate: lastModifiedDate)
                      
                      guard let listView =
                              self.navigationController?.viewControllers.first as? ListViewController else {
                        return
                      }
                      listView.updateTable()
                      
                      self.navigationController?.popViewController(animated: true)
                    }))
    alert.addAction(
      UIAlertAction(title: "취소",
                    style: UIAlertAction.Style.cancel,
                    handler: nil))
    
    return alert
  }
}
