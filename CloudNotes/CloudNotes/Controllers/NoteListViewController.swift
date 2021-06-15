//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import os

final class NoteListViewController: UIViewController {
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Note>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Note>

    // MARK: - Sections for diffable data source

    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Properties
    
    private var listCollectionView: UICollectionView?
    private var dataSource: DataSource?
    private let noteManager: NoteManager
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    private var editingNote: Note?
    var currentIndexPathOfEditingNote: IndexPath {
        guard let editingNote = editingNote,
              let indexPath = dataSource?.indexPath(for: editingNote) else {
            return NoteLocations.indexPathOfFirstNote
        }
        return indexPath
    }
    
    // MARK: - Initializers
    
    init() {
        noteManager = NoteManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        noteManager = NoteManager()
        super.init(coder: coder)
    }
    
    // MARK: - Namespaces
    
    private enum UIItems {
        enum NavigationBar {
            static let title = "메모"
            static let addButtonImage: UIBarButtonItem.SystemItem = .add
        }
        
        enum SwipeAction {
            static let deleteActionImage = UIImage(systemName: "trash")
            static let showActivityViewImage = UIImage(systemName: "square.and.arrow.up")
            static let showActivityViewBackgroundColor: UIColor = .systemBlue
        }
        
        enum AlertControllerConfiguration {
            static var delete: UIAlertController {
                return UIAlertController(title: "Are you sure?", message: "Cannot recover your note after being removed.", preferredStyle: .alert)
            }
        }
        
        enum AlertActionTitle {
            static let deleteButton = "Delete"
            static let cancelButton = "Cancel"
        }
        
        enum Texts {
            static let newLine = "\n"
            static let empty = ""
        }
    }
    
    enum NoteLocations {
        static let indexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCollectionView()
        configureDiffableDataSource()
        noteManager.loadSavedNotes()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = listCollectionView?.indexPathsForSelectedItems?.first {
            listCollectionView?.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - Configure Views and Datasource as Component Methods for `showCollectionView()`
    
    private func configureViews() {
        configureNavigationBar()
        configureCollectionViewHierarchy()
    }
    
    private func showCollectionView() {
        configureViews()
        registerCellNib()
    }
    
    private func registerCellNib() {
        let noteCellNib = UINib(nibName: NoteCollectionViewListCell.reuseIdentifier, bundle: .main)
        listCollectionView?.register(noteCellNib, forCellWithReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier)
    }
    
    // MARK: - Create Layout for Collection View
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self else {
                return nil
            }
            return self.leadingSwipeActionConfiguration(indexPath)
        }
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self else {
                return nil
            }
            return self.trailingSwipeActionConfiguration(indexPath)
        }
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    // MARK: - Configure Hierarchy and Data Source of Collection View
    
    private func configureCollectionViewHierarchy() {
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let noteListCollectionView = listCollectionView else {
            Loggers.ui.fault("\(UIError.collectionViewNotImplemented(location: #function))")
            return
        }
        
        noteListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        noteListCollectionView.backgroundColor = .systemBackground
        view.addSubview(noteListCollectionView)
        noteListCollectionView.delegate = self
    }
    
    private func configureDiffableDataSource() {
        guard let noteListCollectionView = listCollectionView else {
            Loggers.ui.fault("\(UIError.collectionViewNotImplemented(location: #function))")
            return
        }
        
        dataSource = DataSource(collectionView: noteListCollectionView) { collectionView, indexPath, note -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier, for: indexPath) as? NoteCollectionViewListCell
            cell?.configure(with: note)
            return cell
        }
    }
    
    // MARK: - Configure Navigation Bar and Relevant Actions
    
    private func configureNavigationBar() {
        navigationItem.title = UIItems.NavigationBar.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIItems.NavigationBar.addButtonImage, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        let newNote = noteManager.createNewNote(title: UIItems.Texts.empty, body: UIItems.Texts.empty, date: Date())
        editingNote = newNote
        applySnapshot(animatingDifferences: true)
        listCollectionView?.selectItem(at: NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
        showDetailViewController(with: newNote)
    }
    
    // MARK: - Swipe Action Providing Methods
    
    private func trailingSwipeActionConfiguration(_ indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            self.deleteTapped(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIItems.SwipeAction.deleteActionImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func leadingSwipeActionConfiguration(_ indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let showActivityViewAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            self.activityViewTapped(at: indexPath)
            completion(true)
        }
        showActivityViewAction.image = UIItems.SwipeAction.showActivityViewImage
        showActivityViewAction.backgroundColor = UIItems.SwipeAction.showActivityViewBackgroundColor
        return UISwipeActionsConfiguration(actions: [showActivityViewAction])
    }
    
    // MARK: - View Transition Supporting Methods
    
    private func showDetailViewController(with editingNote: Note) {
        guard let noteDetailViewController = noteDetailViewControllerDelegate as? NoteDetailViewController else {
            Loggers.ui.error("\(UIError.typeCastingFailed(subject: "noteDetailViewControllerDelegate", location: #function))")
            return
        }
        
        noteDetailViewControllerDelegate?.showNote(with: editingNote)
        splitViewController?.showDetailViewController(noteDetailViewController, sender: nil)
    }
    
    private func showFirstNoteAfterDeletingNote() {
        guard let firstNote = getNote(at: NoteLocations.indexPathOfFirstNote) else {
            Loggers.data.notice("\(DataError.failedToGetNote(indexPath: NoteLocations.indexPathOfFirstNote, location: #function))")
            return
        }
        editingNote = firstNote
        self.listCollectionView?.selectItem(at: NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
        self.showDetailViewController(with: firstNote)
    }
    
    // MARK: - Get Note from Diffable Data Source
    private func getNote(at indexPath: IndexPath) -> Note? {
        guard let note = dataSource?.itemIdentifier(for: indexPath) else {
            Loggers.data.error("\(DataError.failedToGetNote(indexPath: indexPath, location: #function))")
            return nil
        }
        return note
    }
    
    // MARK: - Delete Supporting Method
    
    private func applyDeletion(at indexPath: IndexPath) {
        guard let noteToDelete = getNote(at: indexPath) else {
            Loggers.data.error("\(DataError.failedToGetNote(indexPath: indexPath, location: #function))")
            return
        }
        noteManager.deleteNote(noteToDelete)
        applySnapshot(animatingDifferences: true)
    }
    
    private func configureDeleteButton(for indexPath: IndexPath) -> UIAlertAction {
        let deleteButton = UIAlertAction(title: UIItems.AlertActionTitle.deleteButton, style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.applyDeletion(at: indexPath)
            
            if self.noteManager.fetchedNotes.isEmpty {
                self.noteDetailViewControllerDelegate?.clearText()
            }
            
            if self.splitViewController?.traitCollection.horizontalSizeClass == .regular {
                self.showFirstNoteAfterDeletingNote()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        return deleteButton
    }
}

// MARK: - Collection View Delegate

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedNote = getNote(at: indexPath) else {
            Loggers.data.error("\(DataError.failedToGetNote(indexPath: indexPath, location: #function))")
            return
        }
        self.editingNote = selectedNote
        showDetailViewController(with: selectedNote)
    }
}

// MARK: - NoteListViewController Actions Delegate (Swipe and Ellipsis Actions)

extension NoteListViewController: NoteListViewControllerActionsDelegate {
    
    func deleteTapped(at indexPath: IndexPath) {
        let deleteAlert = UIItems.AlertControllerConfiguration.delete
        let deleteButton = configureDeleteButton(for: indexPath)
        let cancelButton = UIAlertAction(title: UIItems.AlertActionTitle.cancelButton, style: .cancel)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancelButton)
        present(deleteAlert, animated: true)
    }
    
    func activityViewTapped(at indexPath: IndexPath) {
        guard let selectedNote = getNote(at: indexPath) else {
            Loggers.data.error("\(DataError.failedToGetNote(indexPath: indexPath, location: #function))")
            return
        }
        let items = [selectedNote.title + UIItems.Texts.newLine + selectedNote.body]
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityView.popoverPresentationController?.sourceView = self.view
        self.present(activityView, animated: true)
    }
}

// MARK: - Note List View Controller Delegate (Update Feature)

extension NoteListViewController: NoteListViewControllerDelegate {
    func applyTextUpdate(with newText: String) {
        if let editingNote = self.editingNote {
            noteManager.updateNote(editingNote, with: newText)
        } else {
            guard let newNote = dataSource?.snapshot().itemIdentifiers.first else {
                Loggers.data.error("\(DataError.snapshotIsEmpty(location: #function))")
                return
            }
            noteManager.updateNote(newNote, with: newText)
        }
        applySnapshot(animatingDifferences: false)
        listCollectionView?.selectItem(at: NoteListViewController.NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
    }
    
    /// Use this method after making changes to core data stack. Changes made from core data stack will automatically reflected to diffable data source and the UI elements.
    func applySnapshot(animatingDifferences: Bool) {
        let sections = Section.allCases
        var updated = Snapshot()
        updated.appendSections(sections)
        updated.appendItems(noteManager.fetchedNotes)
        dataSource?.apply(updated, animatingDifferences: animatingDifferences)
    }
}
