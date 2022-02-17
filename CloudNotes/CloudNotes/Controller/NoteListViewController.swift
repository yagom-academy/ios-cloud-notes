//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit
import CoreData

protocol NoteListViewDelegate: AnyObject {
    func noteListView(didSeletedCell row: Int)
}

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = UITableView()
    
    weak var delegate: NoteListViewDelegate?
    var persistantManager: PersistantManager?
    lazy var noteDataSource = CloudNotesDataSource(persistantManager: persistantManager)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupConstraints()
        selectFirstNote()
        setupbackgroundLabel()
    }
    
    private func setupNavigation() {
        title = "메모"
        let addButtonImage = UIImage(systemName: ImageNames.plusImageName)
        let rightButton = UIBarButtonItem(
          image: addButtonImage,
          style: .done,
          target: self,
          action: #selector(addEmptyNote)
        )
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    @objc func addEmptyNote() {
        tableView.performBatchUpdates {
            let emptyNoteInformation = NoteInformation(
                title: "새로운 메모",
                content: "추가 텍스트 없음",
                lastModifiedDate: Date().timeIntervalSince1970
            )
            persistantManager?.save(noteInformation: emptyNoteInformation)
            persistantManager?.notes = persistantManager?.fetch() ?? []
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        } completion: {_ in
            self.tableView.backgroundView?.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = noteDataSource
        tableView.delegate = self
        tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.identifier
        )
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupbackgroundLabel() {
        let backgroundLabel = UILabel()
        backgroundLabel.text = "메모없음"
        backgroundLabel.textColor = .systemGray
        backgroundLabel.font = .preferredFont(forTextStyle: .title1)
        backgroundLabel.textAlignment = .center
        tableView.backgroundView = backgroundLabel
    }
    
    private func selectFirstNote() {
        guard let noteInformations = persistantManager?.notes,
              noteInformations.count > 0 else {
               return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
}

// MARK: - Table View Delegate

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
}
