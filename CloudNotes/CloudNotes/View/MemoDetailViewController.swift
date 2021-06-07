//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit
import CoreData

class MemoDetailViewController: UIViewController {
    private var memo: Memo?
    private var indexPath: IndexPath?
    private weak var memoListViewDelegate: MemoListViewDelegate?

    private lazy var isHorizontalSizeClassRegular = UITraitCollection.current.horizontalSizeClass == .regular

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title1)
        textView.textContainer.maximumNumberOfLines = 1
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()

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

    override func viewWillDisappear(_ animated: Bool) {
        guard let memo = memo,
              let indexPath = indexPath,
              let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        titleTextView.isEditable = false
        descriptionTextView.isEditable = false

        if memo.title != titleTextView.text {
            memo.title = titleTextView.text
        }

        if memo.memoDescription != descriptionTextView.text {
            memo.memoDescription = descriptionTextView.text
        }

        try? context.save()
        memoListViewDelegate?.updateMemo(indexPath: indexPath)
    }

    init(memoListViewDelegate: MemoListViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.memoListViewDelegate = memoListViewDelegate
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func fetchData(memo: Memo, indexPath: IndexPath) {
        self.memo = memo
        titleTextView.text = memo.title
        descriptionTextView.text = memo.memoDescription
        titleTextView.isEditable = true
        descriptionTextView.isEditable = true

        self.indexPath = indexPath
    }

    private func setUpView() {
        view.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        navigationItem.hidesBackButton = isHorizontalSizeClassRegular
        navigationItem.rightBarButtonItem = showMoreButton

        titleTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        descriptionTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
    }

    private func setUpTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.delegate = self

        if let memo = memo {
            let text = memo.title
            titleTextView.text = text
        }

        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 50) // TODO: 적절하게 교체 필요
        ])
    }

    private func setUpDescriptionTextView() {
        view.addSubview(descriptionTextView)
        descriptionTextView.delegate = self

        if let memo = memo {
            descriptionTextView.text = memo.memoDescription
        }

        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func showMoreButtonDidTouched() {
        // FIXME: iPad에서는 actionSheet 띄울 때 error 발생중 대응 해야함
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: shareActionCompletionHandler)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionCompletionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func shareActionCompletionHandler(alert: UIAlertAction) {
        guard let indexPath = indexPath else { return }
        memoListViewDelegate?.shareMemo(indexPath: indexPath)
    }

    private func deleteActionCompletionHandler(alert: UIAlertAction) {
        guard let indexPath = indexPath else { return }
        memoListViewDelegate?.deleteMemo(indexPath: indexPath)

        self.memo = nil
        self.titleTextView.text.removeAll()
        self.titleTextView.isEditable = false
        self.descriptionTextView.text.removeAll()
        self.descriptionTextView.isEditable = false

        navigationController?.popViewController(animated: true)
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if titleTextView.isFirstResponder {
            let latestText = titleTextView.text.last
            if latestText == "\n" || latestText == "\t" {
                titleTextView.text.removeLast()
                descriptionTextView.becomeFirstResponder()
            }
        }
    }
}
