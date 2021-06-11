//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit
import CoreData

class MemoDetailViewController: UIViewController {
    private var indexPath: IndexPath?
    weak var memoDetailViewDelegate: MemoDetailViewDelegate?

    private let titleTextView = MemoTextView(font: UIFont.preferredFont(forTextStyle: .title1))

    private let descriptionTextView = MemoTextView(font: UIFont.preferredFont(forTextStyle: .body))

    private lazy var showMoreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                      style: .plain, target: self,
                                                      action: #selector(showMoreButtonDidTouched))

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTitleTextView()
        setUpDescriptionTextView()
    }

    override func viewDidLayoutSubviews() {
        descriptionTextView.contentOffset = .zero
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let isHorizontalSizeClassRegular = traitCollection.horizontalSizeClass == .regular
        view.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        navigationItem.hidesBackButton = isHorizontalSizeClassRegular
        navigationItem.rightBarButtonItem = showMoreButton

        titleTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        descriptionTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
    }

    private func setUpView() {
        let isHorizontalSizeClassRegular = traitCollection.horizontalSizeClass == .regular
        view.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        navigationItem.hidesBackButton = isHorizontalSizeClassRegular
        navigationItem.rightBarButtonItem = showMoreButton
        navigationItem.rightBarButtonItem?.isEnabled = false

        titleTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        descriptionTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
    }

    private func setUpTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.delegate = self
        titleTextView.isHidden = true

        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setUpDescriptionTextView() {
        view.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionTextView.isHidden = true

        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpData(memo: Memo, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleTextView.text = memo.title
        descriptionTextView.text = memo.memoDescription
        titleTextView.isHidden = false
        descriptionTextView.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func clearField() {
        titleTextView.isHidden = true
        descriptionTextView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        splitViewController?.hide(.secondary)
    }
}

// MARK: - ActionSheet

extension MemoDetailViewController {
    @objc private func showMoreButtonDidTouched() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: shareActionCompletionHandler)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionCompletionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize(width: 100, height: 100))
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.barButtonItem = showMoreButton
        }

        present(alert, animated: true, completion: nil)
    }

    private func shareActionCompletionHandler(alert: UIAlertAction) {
        guard let indexPath = indexPath else { return }
        memoDetailViewDelegate?.memoShareButtonDidTapped(memoIndexPathToShare: indexPath, sourceView: view)
    }

    private func deleteActionCompletionHandler(alert: UIAlertAction) {
        guard let indexPath = indexPath else { return }
        memoDetailViewDelegate?.memoDeleteButtonDidTapped(memoIndexPath: indexPath)
    }
}

// MARK: - UITextViewDelegate

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Change Responder
        if titleTextView.isFirstResponder {
            let latestText = titleTextView.text.last
            if latestText == "\n" || latestText == "\t" {
                titleTextView.text.removeLast()
                descriptionTextView.becomeFirstResponder()
            }
        }

        // Runtime AutoResizing
        let estimatedSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
        textView.constraints.forEach {
            if $0.firstAttribute == .height {
                $0.constant = estimatedSize.height
            }
        }

        // Realtime updateCell
        guard let indexPath = indexPath else { return }

        if textView == titleTextView {
            memoDetailViewDelegate?.memoTitleTextViewDidChanged(memoIndexPathToUpdate: indexPath,
                                                                text: titleTextView.text)
        } else if textView == descriptionTextView {
            memoDetailViewDelegate?.memoDescriptionTextViewDidChanged(memoIndexPathToUpdate: indexPath,
                                                                      text: descriptionTextView.text)
        }
    }
}
