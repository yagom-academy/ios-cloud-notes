//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog
import CoreData

final class NoteListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Note>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Note>
    
    // MARK: - Properties
    
    private var noteListCollectionView: UICollectionView?
    private var dataSource: DataSource?
    private var editingNote: Note?
    private let noteCoreDataManager: NoteCoreDataManager = .shared
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    
    // MARK: - Section for diffable data source
    
    private enum Section: CaseIterable {
        case list
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
            static let delete = UIAlertController(title: "Are you sure?", message: "Cannot recover your note after being removed.", preferredStyle: .alert)
        }
        
        enum AlertAction {
            static let deleteButtonTitle = "Delete"
            static let cancelButtonTitle = "Cancel"
        }
        
        enum TextSymbols {
            static let newLineAsElement: String.Element = "\n"
            static let newLineAsString = "\n"
            static let emptyString = ""
            static let emptySubString: Substring = ""
        }
    }
    
    private enum NoteLocations {
        static let IndexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteCoreDataManager.loadSavedNotes(with: self)
        showNoteList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = noteListCollectionView?.indexPathsForSelectedItems?.first {
            noteListCollectionView?.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - Create a New Note
    
    private func getNewNote(title: String, body: String) -> Note {
        let newNote = Note(context: noteCoreDataManager.persistentContainer.viewContext)
        newNote.title = title
        newNote.body = body
        newNote.lastModified = Date()
        
        return newNote
    }
    
    private func createNewNote() -> Note? {
        guard let dataSource = dataSource else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet(location: #function).localizedDescription)
            return nil
        }
        let snapshot = dataSource.snapshot()
        let newNote = getNewNote(title: UIItems.TextSymbols.emptyString, body: UIItems.TextSymbols.emptyString)
        
        if let firstItemInSnapshot = snapshot.itemIdentifiers.first {
            insert(newNote, to: dataSource, before: firstItemInSnapshot)
        } else {
            append(newNote, to: dataSource)
        }
        
        noteCoreDataManager.saveContext()
        return newNote
    }
    
    // MARK: - Configure Views and Datasource as Component Methods for `showNote()`
    
    private func configureViews() {
        configureNavigationBar()
        configureCollectionViewHierarchy()
    }
    
    private func configureDataSource() {
        configureCollectionViewDataSource()
        updateSnapshot()
    }
    
    private func showNoteList() {
        configureViews()
        registerCellNib()
        configureDataSource()
    }
    
    // MARK: - Cell Nib Registration
    
    private func registerCellNib() {
        let noteCellNib = UINib(nibName: NoteCollectionViewListCell.reuseIdentifier, bundle: .main)
        noteListCollectionView?.register(noteCellNib, forCellWithReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier)
    }
    
    // MARK: - Create Layout for Collection View
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        configuration.leadingSwipeActionsConfigurationProvider = { indexPath in
            return self.leadingSwipeActionConfiguration(indexPath)
        }
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            return self.trailingSwipeActionConfiguration(indexPath)
        }
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    // MARK: - Configure Hierarchy and Data Source of Collection View
    
    private func configureCollectionViewHierarchy() {
        noteListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let noteListCollectionView = noteListCollectionView else {
            os_log(.fault, log: .ui, OSLog.objectCFormatSpecifier, UIError.collectionViewNotSet.localizedDescription)
            return
        }
        noteListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        noteListCollectionView.backgroundColor = .systemBackground
        view.addSubview(noteListCollectionView)
        noteListCollectionView.delegate = self
    }
    
    private func configureCollectionViewDataSource() {
        guard let noteListCollectionView = noteListCollectionView else {
            os_log(.fault, log: .ui, OSLog.objectCFormatSpecifier, UIError.collectionViewNotSet.localizedDescription)
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Note>(
            collectionView: noteListCollectionView
        ) { collectionView, indexPath, note -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier, for: indexPath) as? NoteCollectionViewListCell
            cell?.configure(with: note)
            return cell
        }
    }
    
    private func updateSnapshot() {
        let sections = Section.allCases
        var updated = Snapshot()
        updated.appendSections(sections)
        updated.appendItems(noteCoreDataManager.fetchedNotes)
        dataSource?.apply(updated, animatingDifferences: false)
    }
    
    // MARK: - Configure Navigation Bar and Relevant Actions
    
    private func configureNavigationBar() {
        navigationItem.title = UIItems.NavigationBar.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIItems.NavigationBar.addButtonImage, target: self, action: #selector(addButtonTapped))
    }
    
    private func append(_ newNote: Note, to dataSource: UICollectionViewDiffableDataSource<Section, Note>) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([newNote])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func insert(_ newNote: Note, to dataSource: UICollectionViewDiffableDataSource<Section, Note>, before firstItemInSnapshot: Note) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([newNote], beforeItem: firstItemInSnapshot)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addButtonTapped() {
        guard let newNote = createNewNote() else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToCreateNote(location: #function).localizedDescription)
            return
        }
        noteDetailViewControllerDelegate?.setIndexPathOfSelectedNote(NoteLocations.IndexPathOfFirstNote)
        editingNote = newNote
        showDetailViewController(with: newNote)
    }
    
    // MARK: - Swipe Actions and Supporting Methods
    
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
    
    private func delete(at indexPath: IndexPath) {
        var currentSnapshot = dataSource?.snapshot()
        if let currentNoteIdentifier = dataSource?.itemIdentifier(for: indexPath),
           let noteToDelete = noteCoreDataManager.fetchedResultsController?.object(at: indexPath) {
            currentSnapshot?.deleteItems([currentNoteIdentifier])
            noteCoreDataManager.persistentContainer.viewContext.delete(noteToDelete)
        } else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToDeleteNote(indexPath: indexPath).localizedDescription)
            return
        }
        noteCoreDataManager.saveContext()
    }
    
    // MARK: - View Transition
    
    private func showDetailViewController(with editingNote: Note) {
        guard let noteDetailViewController = noteDetailViewControllerDelegate as? NoteDetailViewController else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.downcastingFailed(subject: "NoteDetailViewController", location: #function).localizedDescription)
            return
        }
        noteDetailViewControllerDelegate?.showNote(with: editingNote)
        splitViewController?.showDetailViewController(noteDetailViewController, sender: nil)
    }
    
    private func showFirstNote() {
        guard let identifierForFirstNote = self.dataSource?.itemIdentifier(for: NoteLocations.IndexPathOfFirstNote) else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet(location: #function).localizedDescription)
            return
        }
        editingNote = identifierForFirstNote
        self.noteDetailViewControllerDelegate?.setIndexPathOfSelectedNote(NoteLocations.IndexPathOfFirstNote)
        self.noteListCollectionView?.selectItem(at: NoteLocations.IndexPathOfFirstNote, animated: false, scrollPosition: .top)
        self.showDetailViewController(with: identifierForFirstNote)
    }
    
    // MARK: - Update Note with New Text from Text View
    
    private func updateNote(with newText: String) -> Note? {
        var text = newText.split(separator: UIItems.TextSymbols.newLineAsElement, omittingEmptySubsequences: false)
        var textHasTitleAtLeast: Bool {
            return text.count >= 1
        }
        var newBodyHasText: Bool {
            return newBody != UIItems.TextSymbols.newLineAsString
        }
        guard let editingNote = editingNote else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.editingNoteNotSet.localizedDescription)
            return nil
        }
        var newTitle = String(text.first ?? UIItems.TextSymbols.emptySubString)
        var newBody = UIItems.TextSymbols.emptyString
        let currentDate = Date()
        
        editingNote.title = newTitle
        editingNote.body = newBody
        editingNote.lastModified = currentDate
        
        if textHasTitleAtLeast {
            newTitle = String(text.removeFirst())
            editingNote.title = newTitle
            newBody = text.joined(separator: UIItems.TextSymbols.newLineAsString)
        }
        
        if newBodyHasText {
            editingNote.body = newBody
        }
        
        return editingNote
    }
    
    /// Call this method when the target note for edit changes to inform the note and location to be changed to related objects such as view controllers.
    private func informEditingNote(_ editingNote: Note, indexPath: IndexPath) {
        self.editingNote = editingNote
        noteDetailViewControllerDelegate?.setIndexPathOfSelectedNote(indexPath)
    }
}

// MARK: - Collection View Delegate

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let editingNote = dataSource?.itemIdentifier(for: indexPath) else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet(location: #function).localizedDescription)
            return
        }
        informEditingNote(editingNote, indexPath: indexPath)
        showDetailViewController(with: editingNote)
    }
}

// MARK: - Note List View Controller Delegate

extension NoteListViewController: NoteListViewControllerDelegate {
    func changeNote(with newText: String) {
        guard let newNote = updateNote(with: newText),
              var snapshot = dataSource?.snapshot() else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet(location: #function).localizedDescription)
            return
        }
        
        snapshot.deleteItems([newNote])
        
        guard let firstNoteInSnapshot = snapshot.itemIdentifiers.first else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.snapshotIsEmpty(location: #function).localizedDescription)
            return
        }
        
        snapshot.insertItems([newNote], beforeItem: firstNoteInSnapshot)
        noteListCollectionView?.scrollToItem(at: NoteLocations.IndexPathOfFirstNote, at: .top, animated: true)
        noteCoreDataManager.saveContext()
    }
}

// MARK: - NSFetchedResultsController Delegate

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
        noteListCollectionView?.selectItem(at: NoteLocations.IndexPathOfFirstNote, animated: false, scrollPosition: .top)
    }
}

// MARK: - NoteListViewController Actions Delegate

extension NoteListViewController: NoteListViewControllerActionsDelegate {
    func deleteTapped(at indexPath: IndexPath) {
        let alert = UIItems.AlertControllerConfiguration.delete
        let deleteButton = UIAlertAction(title: UIItems.AlertAction.deleteButtonTitle, style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.delete(at: indexPath)
            if self.splitViewController?.traitCollection.horizontalSizeClass == .regular {
                self.showFirstNote()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelButton = UIAlertAction(title: UIItems.AlertAction.cancelButtonTitle, style: .cancel)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func activityViewTapped(at indexPath: IndexPath) {
        guard let selectedNote = self.dataSource?.itemIdentifier(for: indexPath) else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet(location: #function).localizedDescription)
            return
        }
        let items = [selectedNote.title + UIItems.TextSymbols.newLineAsString + selectedNote.body]
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityView.popoverPresentationController?.sourceView = self.view
        self.present(activityView, animated: true)
    }
}
