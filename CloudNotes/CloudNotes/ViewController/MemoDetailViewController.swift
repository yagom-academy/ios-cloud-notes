//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MemoDetailViewController: UIViewController {
  private let viewModel = MemoDetailViewModel()
  var delegate: MemoDetailViewDelegate?
  
  lazy var textView: UITextView = {
    let textView = UITextView()
    textView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    textView.frame.origin = .zero
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.preferredFont(forTextStyle: .title3)
    textView.text = viewModel.content
    return textView
  }()
  
  lazy var showmoreBarButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                 style: .plain,
                                 target: self,
                                 action: #selector(touchShowMoreButton))
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(textView)
    self.navigationItem.rightBarButtonItem = showmoreBarButton
    self.viewModel.delegate = self
    self.textView.delegate = self
    configureConstraints()
    configureTestViewBackgroundColor()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if previousTraitCollection?.horizontalSizeClass == .compact {
      textView.backgroundColor = .white
    } else if previousTraitCollection?.horizontalSizeClass == .regular {
      textView.backgroundColor = .systemGray4
    }
  }
  
  private func configureTestViewBackgroundColor() {
    if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
      textView.backgroundColor = .systemGray4
    } else if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
      textView.backgroundColor = .white
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
  
  func configure(with memo: Memo, indexPath: IndexPath) {
    viewModel.configure(with: memo, indexPath: indexPath)
  }
  
  func changeIndex(_ indexPath: IndexPath) {
    viewModel.changeIndex(indexPath)
  }
  
  @objc func touchShowMoreButton() {
    guard let index = viewModel.indexPath else { return }
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let share = UIAlertAction(title: "Share", style: .default, handler: { (_) in
      self.delegate?.touchShareButton(indexPath: index)
    })
    let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
      self.delegate?.touchDeleteButton(indexPath: index)
    })
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(share)
    alert.addAction(delete)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}

extension MemoDetailViewController: MemoDetailViewModelDelegate {
  func changeMemo(content: String) {
    textView.text = content
  }
}

extension MemoDetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let seperatedText = seperateTitleBody(text: textView.text)
    guard let indexPath = viewModel.indexPath else { return }
    delegate?.textViewDidChanged(indexPath: indexPath,
                                 title: seperatedText.title,
                                 body: seperatedText.body)
  }
  
  private func seperateTitleBody(text: String) -> (title: String, body: String) {
    let splitString = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
    var title: String = String()
    var body: String = String()
    switch splitString.count {
    case 1:
      title = String(splitString[0])
    case 2:
      title = String(splitString[0])
      body = String(splitString[1])
    default:
      break
    }
    return (title, body)
  }
}
