//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

class MemoViewController: UIViewController {
  let viewModel = MemoViewModel()
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.keyboardDismissMode = .onDrag
    textView.isEditable = false
    
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    updateUI()
    view.addSubview(textView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textView.frame = view.bounds
  }
  
  func updateUI() {
    if let memoInfo = self.viewModel.memoInfo {
      let text = """
        \(memoInfo.title)
        \n
        \(memoInfo.body)
        """
      textView.text = text
      textView.isEditable = true
    }
  }
  
  func configureNavigationBar() {
    // action -> #selector(addTapped)
    let ellipsisImage = UIImage(systemName: "ellipsis.circle")
    let ellipsis = UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = ellipsis
  }
}
