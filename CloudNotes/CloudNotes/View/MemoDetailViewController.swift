//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {

    // MARK: - Properties
    private var memoCellViewModel: MemoCellViewModel? {
        didSet {
            updateMemoCellViewModel()
        }
    }

    private let scrollView = UIScrollView()

    private var titleTextView: UITextView = {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = false

        return textView
    }()

    private var bodyTextView: UITextView = {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = false

        return textView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScrollViewAnchor()
        configureTitleViewAnchor()
        configureBodyViewAnchor()
    }

    // MARK: - Methods
    func configure(with memo: MemoCellViewModel) {
        self.memoCellViewModel = memo
    }

    private func updateMemoCellViewModel() {
        titleTextView.text = memoCellViewModel?.title
        bodyTextView.text = memoCellViewModel?.body
    }
}

// MARK: - View methods
extension MemoDetailViewController {

    private func changeBackgroundColor(of view: UIView, by color: UIColor) {
        view.backgroundColor = color
    }
}

// MARK: - Auto Layout
extension MemoDetailViewController {

    private func configureScrollViewAnchor() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(scrollView)
        changeBackgroundColor(of: scrollView, by: .white)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailingConstraint = scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        let topConstraint = scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)

        let scrollViewConstraints = [leadingConstraint,
                                     trailingConstraint,
                                     topConstraint,
                                     bottomConstraint]
        NSLayoutConstraint.activate(scrollViewConstraints)
    }

    private func configureTitleViewAnchor() {
        let contentLayout = scrollView.contentLayoutGuide
        let frameLayout = scrollView.frameLayoutGuide

        scrollView.addSubview(titleTextView)

        titleTextView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = titleTextView.leadingAnchor.constraint(equalTo: contentLayout.leadingAnchor)
        let trailingConstraint = titleTextView.trailingAnchor.constraint(equalTo: contentLayout.trailingAnchor)
        let topConstraint = titleTextView.topAnchor.constraint(equalTo: contentLayout.topAnchor)
        let widthConstraint = titleTextView.widthAnchor.constraint(equalTo: frameLayout.widthAnchor)

        let titleTextViewConstraints = [leadingConstraint,
                                        trailingConstraint,
                                        topConstraint,
                                        widthConstraint]
        NSLayoutConstraint.activate(titleTextViewConstraints)
    }

    private func configureBodyViewAnchor() {
        let contentLayout = scrollView.contentLayoutGuide
        let frameLayout = scrollView.frameLayoutGuide

        scrollView.addSubview(bodyTextView)

        bodyTextView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = bodyTextView.leadingAnchor.constraint(equalTo: contentLayout.leadingAnchor)
        let trailingConstraint = bodyTextView.trailingAnchor.constraint(equalTo: contentLayout.trailingAnchor)
        let topConstraint = bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor)
        let bottomConstraint = bodyTextView.bottomAnchor.constraint(equalTo: contentLayout.bottomAnchor)
        let widthConstraint = bodyTextView.widthAnchor.constraint(equalTo: frameLayout.widthAnchor)

        let bodyTextViewConstraints = [leadingConstraint,
                                       trailingConstraint,
                                       topConstraint,
                                       bottomConstraint,
                                       widthConstraint]
        NSLayoutConstraint.activate(bodyTextViewConstraints)
    }
}
