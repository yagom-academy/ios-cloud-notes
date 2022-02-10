//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

class NoteDetailViewController: UIViewController {
    var noteDataSource: CloudNotesDataSource?
    private let noteDetailScrollView = NoteDetailScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        noteDetailScrollView.delegate = self
        setupNoteDetailScrollView()
    }
    
    private func setupNoteDetailScrollView() {
        view.addSubview(noteDetailScrollView)
        noteDetailScrollView.setupConstraint(view: view)
    }
    
    func setupDetailView(index: Int) {
        if let information = noteDataSource?.noteInformations?[index] {
            noteDetailScrollView.configure(with: information)
            scrollTextViewToVisible()
        }
    }
    
    private func scrollTextViewToVisible() {
        DispatchQueue.main.async { [weak self] in
            if let dateLabelHeight = self?.noteDetailScrollView.lastModifiedDateLabel.frame.height {
                self?.noteDetailScrollView.setContentOffset(CGPoint(x: 0, y: dateLabelHeight), animated: true)
            }
        }
    }
}

extension NoteDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let dateLabelHeight = noteDetailScrollView.lastModifiedDateLabel.frame.height

        if scrollView.contentOffset.y < dateLabelHeight {
            targetContentOffset.pointee = CGPoint(x: 0, y: 0)
        }
    }
}
