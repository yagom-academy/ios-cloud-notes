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
    
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
    view.addSubview(textView)
    
    configureNavigationBar()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textView.frame = view.bounds
  }
  
  func updateUI() {
    if let memoInfo = self.viewModel.memoInfo {
      textView.text = memoInfo.memo
    }
  }
  
  func configureNavigationBar() {
    let ellipsisImage = UIImage(systemName: "ellipsis.circle")
    let ellipsis = UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = ellipsis
  }
}
