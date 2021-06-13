//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) var listCollectionView: UICollectionView?
    private(set) var noteManager: NoteManager?
    
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
        
        enum AlertAction {
            static let deleteButtonTitle = "Delete"
            static let cancelButtonTitle = "Cancel"
        }
        
        enum TextSymbols {
            static let newLineAsString = "\n"
        }
    }
    
    private enum NoteLocations {
        static let indexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCollectionView()
        implementNoteManager()
        noteManager?.loadSavedNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = listCollectionView?.indexPathsForSelectedItems?.first {
            listCollectionView?.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - Configure Views and Datasource as Component Methods for `showNote()`
    
    private func configureViews() {
        configureNavigationBar()
        configureCollectionViewHierarchy()
    }
    
    private func showCollectionView() {
        configureViews()
        registerCellNib()
    }
    
    // MARK: - Cell Nib Registration
    
    private func registerCellNib() {
        let noteCellNib = UINib(nibName: NoteCollectionViewListCell.reuseIdentifier, bundle: .main)
        listCollectionView?.register(noteCellNib, forCellWithReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier)
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
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let noteListCollectionView = listCollectionView else {
            os_log(.fault, log: .ui, OSLog.objectCFormatSpecifier, UIError.collectionViewNotSet.localizedDescription)
            return
        }
        noteListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        noteListCollectionView.backgroundColor = .systemBackground
        view.addSubview(noteListCollectionView)
        noteListCollectionView.delegate = self
    }
    
    // MARK: - Configure Navigation Bar and Relevant Actions
    
    private func configureNavigationBar() {
        navigationItem.title = UIItems.NavigationBar.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIItems.NavigationBar.addButtonImage, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        guard let newNote = noteManager?.create() else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToCreateNote(location: #function).localizedDescription)
            return
        }
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
    
    // MARK: - View Transition
    
    private func showDetailViewController(with editingNote: Note) {
        guard let noteDetailViewController = splitViewController?.viewController(for: .secondary) as? NoteDetailViewController else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.downcastingFailed(subject: "NoteDetailViewController", location: #function).localizedDescription)
            return
        }
        noteDetailViewController.showNote(with: editingNote)
        splitViewController?.showDetailViewController(noteDetailViewController, sender: nil)
    }
    
    private func showFirstNoteAfterDeletingNote() {
        guard let firstNote = noteManager?.getNote(at: NoteLocations.indexPathOfFirstNote) else {
            return
        }
        self.listCollectionView?.selectItem(at: NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
        self.showDetailViewController(with: firstNote)
    }
    
    // MARK: - Implement Note Manager
    
    private func implementNoteManager() {
        noteManager = NoteManager()
        noteManager?.listViewDataSource = self
        noteManager?.noteDetailViewControllerDelegate = splitViewController?.viewController(for: .secondary) as? NoteDetailViewController
    }

}

// MARK: - Collection View Delegate

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let editingNote = noteManager?.getNote(at: indexPath) else {
            return
        }
        showDetailViewController(with: editingNote)
    }
}

// MARK: - NoteListViewController Actions Delegate

extension NoteListViewController: NoteListViewControllerActionsDelegate {
    
    func deleteTapped(at indexPath: IndexPath) {
        let deleteAlert = UIItems.AlertControllerConfiguration.delete
        
        if deleteAlert.actions.isEmpty {
            addActions(to: deleteAlert, for: indexPath)
        }
        
        present(deleteAlert, animated: true)
    }
    
    private func addActions(to deleteAlert: UIAlertController, for indexPath: IndexPath) {
        let deleteButton = UIAlertAction(title: UIItems.AlertAction.deleteButtonTitle, style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.noteManager?.delete(at: indexPath)
            if self.splitViewController?.traitCollection.horizontalSizeClass == .regular {
                self.showFirstNoteAfterDeletingNote()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelButton = UIAlertAction(title: UIItems.AlertAction.cancelButtonTitle, style: .cancel)
        
        deleteAlert.addAction(deleteButton)
        deleteAlert.addAction(cancelButton)
    }
    
    func activityViewTapped(at indexPath: IndexPath) {
        guard let selectedNote = noteManager?.getNote(at: indexPath) else {
            return
        }
        let items = [selectedNote.title + UIItems.TextSymbols.newLineAsString + selectedNote.body]
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityView.popoverPresentationController?.sourceView = self.view
        self.present(activityView, animated: true)
    }
}

// MARK: - List View Data Source
extension NoteListViewController: ListViewDataSource { }
