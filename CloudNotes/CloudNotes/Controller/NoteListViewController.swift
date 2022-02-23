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
    func setupEmptyNoteContents()
    func setupNotEmptyNoteContents()
    func sharedNoteActionWithSwipe(index: Int)
    func deleteNoteActionWithSwipe(index: Int)
}

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = UITableView()
    weak var delegate: NoteListViewDelegate?
    lazy var dataSource = NoteListDataSource(persistentManager: persistentManager)
    var persistentManager: PersistentManager?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupConstraints()
        selectNote(with: 0)
        setupbackgroundLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .systemBackground
        self.tableView.backgroundView?.isHidden = persistentManager?.notes.count == 0 ? false : true
    }
    
    // MARK: - internal Methods
    
    func updateListView(index: Int, noteInformation: NoteInformation) {
        if let note = persistentManager?.notes[index] {
            persistentManager?.update(object: note, noteInformation: noteInformation)
            DispatchQueue.main.async {
                self.tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            view.endEditing(true)
        }
    }
    
    func deleteNote(object: NSManagedObject, indexPath: IndexPath) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .fade)
            persistentManager?.delete(object: object)
        } completion: { _ in
            if self.persistentManager?.notes.count == indexPath.row {
                self.selectNote(with: indexPath.row - 1)
            } else {
                self.selectNote(with: indexPath.row)
            }
        }
    }
    
    // MARK: - private Methods
    
    private func setupNavigation() {
        title = "메모"
        let addButtonImage = UIImage(systemName: ImageNames.plusImageName)
        let rightButton = UIBarButtonItem(
          image: addButtonImage,
          style: .done,
          target: self,
          action: #selector(addNewNote)
        )
        navigationItem.setRightBarButton(rightButton, animated: false)
        
    }
    
    private func setUpEmptyNotes() {
        DispatchQueue.main.async {
            self.tableView.backgroundView?.isHidden = false
        }
        self.delegate?.setupEmptyNoteContents()
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
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
    
    @objc private func addNewNote() {
        tableView.performBatchUpdates {
            let emptyNoteInformation = NoteInformation(
                title: "",
                content: "",
                lastModifiedDate: Date().timeIntervalSince1970
            )
            persistentManager?.save(noteInformation: emptyNoteInformation)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        } completion: {_ in
            self.tableView.backgroundView?.isHidden = true
            self.delegate?.setupNotEmptyNoteContents()
            self.tableView.reloadData()
            self.selectNote(with: 0)
        }
    }
    
    private func selectNote(with index: Int) {
        guard let notes = persistentManager?.notes,
              notes.count > 0 else {
                  self.setUpEmptyNotes()
                  return
              }
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
}

// MARK: - Table View Delegate

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { _, _, _ in
            self.delegate?.deleteNoteActionWithSwipe(index: indexPath.row)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: ImageNames.trashImageName)
        
        let shared = UIContextualAction(style: .normal, title: "Shared") { _, _, _ in
            self.delegate?.sharedNoteActionWithSwipe(index: indexPath.row)
        }
        shared.backgroundColor = .systemBlue
        shared.image = UIImage(systemName: ImageNames.sharedImageName)
        
        return UISwipeActionsConfiguration(actions: [delete, shared])
    }
}
