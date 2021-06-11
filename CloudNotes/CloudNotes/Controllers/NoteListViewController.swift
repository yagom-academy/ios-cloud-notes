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
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    private let noteCoreDataManager: NoteCoreDataManager = .shared
    
    // MARK: - Section for diffable data source
    
    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Namespaces
    
    enum NoteData {
        static let IndexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    private enum NavigationBarItems {
        static let title = "메모"
        static let addButtonImage: UIBarButtonItem.SystemItem = .add
    }
    
    private enum TextSymbols {
        static let newLineAsElement: String.Element = "\n"
        static let newLineAsString = "\n"
        static let emptyString = ""
        static let emptySubString: Substring = ""
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
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet.localizedDescription)
            return nil
        }
        
        let snapshot = dataSource.snapshot()
        let newNote = getNewNote(title: TextSymbols.emptyString, body: TextSymbols.emptyString)
        
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
        navigationItem.title = NavigationBarItems.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: NavigationBarItems.addButtonImage, target: self, action: #selector(addButtonTapped))
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
            return
        }
        
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
            self.deleteTapped(noteAt: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func leadingSwipeActionConfiguration(_ indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let callActivityViewAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else {
                return
            }
            self.activityViewTapped(at: indexPath)
        }
        callActivityViewAction.image = UIImage(systemName: "square.and.arrow.up")
        callActivityViewAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [callActivityViewAction])
    }
    
    private func deleteTapped(noteAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure?", message: "Cannot recover your note after being removed.", preferredStyle: .alert)
        let removeButton = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.delete(at: indexPath)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(removeButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
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
    
    private func activityViewTapped(at indexPath: IndexPath) {
        guard let selectedNote = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        let items = [selectedNote.title + TextSymbols.newLineAsString + selectedNote.body]
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityView.popoverPresentationController?.sourceView = self.view
        
        self.present(activityView, animated: true)
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
    
    // MARK: - Update Note with New Text from Text View
    
    private func updateNote(with newText: String) -> Note? {
        var text = newText.split(separator: TextSymbols.newLineAsElement, omittingEmptySubsequences: false)
        guard let editingNote = editingNote else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.editingNoteNotSet.localizedDescription)
            return nil
        }
        
        var newTitle = String(text.first ?? TextSymbols.emptySubString)
        var newBody = TextSymbols.emptyString
        let currentDate = Date()
        
        editingNote.title = newTitle
        editingNote.body = newBody
        editingNote.lastModified = currentDate
        
        if text.count > 1 {
            newTitle = String(text.removeFirst())
            newBody = text.joined(separator: TextSymbols.newLineAsString)
            editingNote.title = newTitle
            editingNote.body = newBody
        }
        
        return editingNote
    }
}

// MARK: - Collection View Delegate

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editingNote = dataSource?.itemIdentifier(for: indexPath)
        guard let editingNote = editingNote else {
            return
        }
        showDetailViewController(with: editingNote)
    }
}

// MARK: - Note List View Controller Delegate

extension NoteListViewController: NoteListViewControllerDelegate {
    func changeNote(with newText: String) {
        guard let newNote = updateNote(with: newText),
              var snapshot = dataSource?.snapshot() else {
            return
        }
        
        snapshot.deleteItems([newNote])
        
        if let firstNoteInSnapshot = snapshot.itemIdentifiers.first {
            snapshot.insertItems([newNote], beforeItem: firstNoteInSnapshot)
        }
        
        noteListCollectionView?.scrollToItem(at: NoteData.IndexPathOfFirstNote, at: .top, animated: true)
        noteCoreDataManager.saveContext()
    }
}

// MARK: - NSFetchedResultsController Delegate

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
