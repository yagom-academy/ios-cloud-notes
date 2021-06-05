//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MemoDetailViewController: UIViewController {

  private let viewModel = MemoDetailViewModel()
  
  lazy var textView: UITextView = {
    let textView = UITextView()
    
    if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
      textView.backgroundColor = .systemGray4
    } else if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
      textView.backgroundColor = .white
    }
    
    textView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    textView.frame.origin = .zero
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.preferredFont(forTextStyle: .title3)
    textView.text = viewModel.content
    return textView
  }()
  
  lazy var editButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                    style: .plain, target: self, action: #selector(editMemo))
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(textView)
    self.navigationItem.rightBarButtonItem = editButton
    configureConstraints()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if previousTraitCollection?.horizontalSizeClass == .compact {
      textView.backgroundColor = .white
    } else if previousTraitCollection?.horizontalSizeClass == .regular {
      textView.backgroundColor = .systemGray4
    }
  }
  
  private func configureConstraints() {
    let safeArea = self.view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)  
    ])
  }
  
  func configure(with memo: Memo) {
    viewModel.configure(with: memo)
  }
  
  @objc func editMemo() {
    
  }
}
