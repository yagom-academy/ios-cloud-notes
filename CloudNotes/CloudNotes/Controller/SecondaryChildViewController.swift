//
//  SecondaryChildViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class SecondaryChildViewController: UIViewController {
    weak var delegate: NoteUpdater?
    private var bodyTextView = UITextView()
    private var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        bodyTextView.delegate = self
    }
    
    func initContent(of note: Note, at indexPath: IndexPath) {
        setUpDetailView(indexPath: indexPath)
        showContent(of: note)
        styleContent()
        layoutContent()
        scrollToContentTop()
    }
    
    private func setUpDetailView(indexPath: IndexPath) {
        self.indexPath = indexPath
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: nil
        )
    }

    private func showContent(of note: Note) {
        bodyTextView.text = note.title + String.doubleLineBreaks + note.body
    }
    
    private func styleContent() {
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        view.backgroundColor = .white
    }
    
    private func layoutContent() {
        view.addSubview(bodyTextView)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bodyTextView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bodyTextView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bodyTextView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func scrollToContentTop() {
        let contentHeight = bodyTextView.contentSize.height
        let contentOffset = CGPoint(x: .zero, y: -contentHeight)
        bodyTextView.setContentOffset(contentOffset, animated: true)
    }
}

extension SecondaryChildViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let indexPath = indexPath else { return }

        delegate?.update(note: Note(title: textView.title ?? String.empty,
                                    body: textView.body ?? String.empty,
                                    lastModified: Date().timeIntervalSince1970),
                         at: indexPath)
    }
}
