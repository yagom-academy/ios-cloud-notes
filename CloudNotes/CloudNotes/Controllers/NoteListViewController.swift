//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

final class NoteListViewController: UIViewController {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Note>
    // MARK: - Properties
    private var noteListCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Note>?
    private var notes: [Note] = []
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    private(set) var editingNote: Note?
    
    // MARK: - Section for diffable data source
    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Namespaces
    enum NoteData {
        static let sampleFileName = "sample"
        static var newNoteConfiguration: Note {
            Note(title: "", body: "", lastModified: Date())
        }
    }
    
    private enum NavigationBarItems {
        static let title = "메모"
        static let addButtonImage: UIBarButtonItem.SystemItem = .add
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes(from: NoteData.sampleFileName)
        sortNotes()
        showNoteList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = noteListCollectionView?.indexPathsForSelectedItems?.first {
            noteListCollectionView?.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - Load Notes from Sample JSON
    private func loadNotes(from assetName: String) {
        let decodedResult = JSONDecoder().decode(to: [Note].self, from: assetName)
        switch decodedResult {
        case .success(let decodedNotes):
            notes = decodedNotes
        case .failure(let dataError):
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, dataError.localizedDescription)
        }
    }
    
    private func sortNotes() {
        notes.sort { current, next in
            current.lastModified > next.lastModified
        }
    }
    
    // MARK: - Configure Views and Datasource as Component Methods for `showNote()`
    private func configureViews() {
        configureNavigationBar()
        configureCollectionViewHierarchy()
    }
    
    private func configureDataSource() {
        configureCollectionViewDataSource()
        applyInitialSnapshot()
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
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
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
    
    private func applyInitialSnapshot() {
        let sections = Section.allCases
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems(notes)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Configure Navigation Bar and Relevant Actions
    private func configureNavigationBar() {
        navigationItem.title = NavigationBarItems.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: NavigationBarItems.addButtonImage, target: self, action: #selector(addTapped))
    }
    
    private func append(_ newNote: Note, to dataSource: UICollectionViewDiffableDataSource<Section, Note>) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([NoteData.newNoteConfiguration])
        notes.append(NoteData.newNoteConfiguration)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func insert(_ newNote: Note, to dataSource: UICollectionViewDiffableDataSource<Section, Note>, before firstItemInSnapshot: Note) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([NoteData.newNoteConfiguration], beforeItem: firstItemInSnapshot)
        notes.insert(newNote, at: notes.startIndex)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addTapped() {
        guard let dataSource = dataSource else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet.localizedDescription)
            return
        }
        
        let snapshot = dataSource.snapshot()
        let newNote = NoteData.newNoteConfiguration
        
        if let firstItemInSnapshot = snapshot.itemIdentifiers.first {
            insert(newNote, to: dataSource, before: firstItemInSnapshot)
        } else {
            append(newNote, to: dataSource)
        }
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
}

// MARK: - Collection View Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editingNote = dataSource?.itemIdentifier(for: indexPath)
        guard let editingNote = editingNote else { return }
        showDetailViewController(with: editingNote)
    }
}

// MARK: - Note List View Controller Delegate
extension NoteListViewController: NoteListViewControllerDelegate {
    func changeNote(with newNote: Note) {
        guard var snapshot = dataSource?.snapshot() else { return }
        guard let firstNote = snapshot.itemIdentifiers.first else { return }
        guard let editingNote = editingNote else { return }
        
        if editingNote == firstNote {
            notes[0] = newNote
            snapshot.deleteAllItems()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(notes)
        } else {
            snapshot.deleteItems([editingNote])
            snapshot.insertItems([newNote], beforeItem: firstNote)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.dataSource?.apply(snapshot, animatingDifferences: false)
        }
        
        notes = snapshot.itemIdentifiers
        noteListCollectionView?.scrollToItem(at: (dataSource?.indexPath(for: newNote))!, at: .top, animated: true)
    }
}
