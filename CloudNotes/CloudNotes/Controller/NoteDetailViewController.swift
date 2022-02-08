//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

class NoteDetailViewController: UIViewController {
    private let noteDetailScrollView = NoteDetailScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoteDetailScrollView()
    }
    
    private func setupNoteDetailScrollView() {
        view.addSubview(noteDetailScrollView)
        noteDetailScrollView.setupConstraint(view: view)
    }
}
