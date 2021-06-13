//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

final class NoteListViewController: UIViewController {
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Note>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Note>

    // MARK: - Sections for diffable data source

    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Properties
    
    private(set) var listCollectionView: UICollectionView?
    private var dataSource: DataSource?
    private let noteManager: NoteManager
    
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
        
        enum TextSymbols {
            static let newLine = "\n"
            static let emptyString = ""
        }
    }
    
    enum NoteLocations {
        static let indexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCollectionView()
        setNoteManagerDelegate()
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
            os_log(.fault, log: .ui, OSLog.objectCFormatSpecifier, UIError.collectionViewNotSet(location: #function).localizedDescription)
            return
        }
        noteListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        noteListCollectionView.backgroundColor = .systemBackground
        view.addSubview(noteListCollectionView)
        noteListCollectionView.delegate = self
    }
    
    private func configureDiffableDataSource() {
        guard let noteListCollectionView = listCollectionView else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToConfigureDiffableDataSource(location: #function).localizedDescription)
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
        let newNote = noteManager.create(title: UIItems.TextSymbols.emptyString, body: UIItems.TextSymbols.emptyString, date: Date())
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
        guard let noteDetailViewController = splitViewController?.viewController(for: .secondary) as? NoteDetailViewController else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.typeCastingFailed(subject: "NoteDetailViewController", location: #function).localizedDescription)
            return
        }
        noteDetailViewController.showNote(with: editingNote)
        splitViewController?.showDetailViewController(noteDetailViewController, sender: nil)
    }
    
    private func showFirstNoteAfterDeletingNote() {
        guard let firstNote = noteManager.getNote(at: NoteLocations.indexPathOfFirstNote) else {
            
            return
        }
        self.listCollectionView?.selectItem(at: NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
        self.showDetailViewController(with: firstNote)
    }
    
    // MARK: - Note Manager
    
    private func setNoteManagerDelegate() {
        guard let secondaryViewController = splitViewController?.viewController(for: .secondary)  else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.cannotFindSplitViewController(location: #function).localizedDescription)
            return
        }
        guard let noteDetailViewController = secondaryViewController as? NoteDetailViewController else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.typeCastingFailed(subject: "secondaryViewController", location: #function).localizedDescription)
            return
        }
        noteManager.noteDetailViewControllerDelegate = noteDetailViewController
    }
    
    private func applyDeletion(at indexPath: IndexPath) {
        guard let noteToDelete = noteManager.getNote(at: indexPath) else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToDeleteNote(indexPath: indexPath).localizedDescription)
            return
        }
        
        noteManager.delete(noteToDelete)
        applySnapshot(animatingDifferences: true)
    }
}

// MARK: - Collection View Delegate

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let editingNote = noteManager.getNote(at: indexPath) else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.noteManagerNotImplemented(location: #function).localizedDescription)
            return
        }
        showDetailViewController(with: editingNote)
    }
}

// MARK: - NoteListViewController Actions Delegate (Swipe and Ellipsis Actions)

extension NoteListViewController: NoteListViewControllerActionsDelegate {
    
    func deleteTapped(at indexPath: IndexPath) {
        let deleteAlert = UIItems.AlertControllerConfiguration.delete
        
        let deleteButton = UIAlertAction(title: UIItems.AlertActionTitle.deleteButton, style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.applyDeletion(at: indexPath)
            
            if self.splitViewController?.traitCollection.horizontalSizeClass == .regular {
                self.showFirstNoteAfterDeletingNote()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelButton = UIAlertAction(title: UIItems.AlertActionTitle.cancelButton, style: .cancel)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancelButton)
        present(deleteAlert, animated: true)
    }
    
    func activityViewTapped(at indexPath: IndexPath) {
        guard let selectedNote = noteManager.getNote(at: indexPath) else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.noteManagerNotImplemented(location: #function).localizedDescription)
            return
        }
        let items = [selectedNote.title + UIItems.TextSymbols.newLine + selectedNote.body]
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityView.popoverPresentationController?.sourceView = self.view
        self.present(activityView, animated: true)
    }
}

// MARK: - Note List View Controller Delegate (Update Feature)

extension NoteListViewController: NoteListViewControllerDelegate {
    func applyTextUpdate(with newText: String) {
        noteManager.update(with: newText)
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        let sections = Section.allCases
        var updated = Snapshot()
        updated.appendSections(sections)
        updated.appendItems(noteManager.fetchedNotes)
        dataSource?.apply(updated, animatingDifferences: animatingDifferences)
    }
}
