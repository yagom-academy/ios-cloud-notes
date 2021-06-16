//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

final class MemoViewController: UIViewController {
  let viewModel = MemoViewModel()
  
  private let titleTextField: UITextField = {
    let textField = UITextField()
    
    return textField
  }()
  
  private let bodyTextView: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = UIColor.gray
    textView.keyboardDismissMode = .onDrag
    
    return textView
  }()
  
  private let textStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    textStackView.addArrangedSubview(titleTextField)
    textStackView.addArrangedSubview(bodyTextView)
    view.addSubview(textStackView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textStackView.frame = view.bounds
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if titleTextField.text == "" && bodyTextView.text == "" {
      // TODO: - delete logic
    } else {
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
      bodyTextView.isEditable = true
    }
  }
  
  func configureNavigationBar() {
    let ellipsisImage = UIImage(systemName: "ellipsis.circle")
    let ellipsis = UIBarButtonItem(image: ellipsisImage,
                                   style: .plain,
                                   target: self, action: nil)
    navigationItem.rightBarButtonItem = ellipsis
  }
  
  @objc private func buttonPressed(_ sender: Any) {
    guard let listView =
            self.navigationController?.viewControllers.first as? ListViewController else {
      return
    }
    listView.updateTable()
    
    self.navigationController?.popViewController(animated: true)
  }
}
