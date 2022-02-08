//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

class NoteDetailViewController: UIViewController {
    private var noteDetailScrollView = NoteDetailScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noteDetailScrollView)
        noteDetailScrollView.setupConstraint(view: view)
    }
}
