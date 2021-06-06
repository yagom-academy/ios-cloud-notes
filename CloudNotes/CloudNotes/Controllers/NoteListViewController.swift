//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

final class NoteListViewController: UIViewController {
    // MARK: - Properties
    private var noteListCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Note>?
    private var notes: [Note] = []
    private weak var noteSplitViewControllerDelegate: NoteShowable?
    
    // MARK: - Initializers
    init(noteSplitViewDelegate: NoteShowable) {
        super.init(nibName: nil, bundle: nil)
        self.noteSplitViewControllerDelegate = noteSplitViewDelegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Section for diffable data source
    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Namespaces
    enum NoteData {
        static let sampleFileName = "sample"
        static var newNoteConfiguration: Note {
            Note(title: "새 메모", body: "", lastModified: Date())
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
        configureNavigationBar()
        configureCollectionViewHierarchy()
        registerCellNib()
        configureCollectionViewDataSource()
        applyInitialSnapshot()
    }
}

// MARK: - Load Notes from Sample JSON
extension NoteListViewController {
    private func loadNotes(from assetName: String) {
        let decodedResult = JSONDecoder().decode(to: [Note].self, from: assetName)
        switch decodedResult {
        case .success(let decodedNotes):
            notes = decodedNotes
        case .failure(let dataError):
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, dataError.localizedDescription)
        }
    }
}

// MARK: - Cell Nib Registration
extension NoteListViewController {
    private func registerCellNib() {
        let noteCellNib = UINib(nibName: NoteCollectionViewListCell.reuseIdentifier, bundle: .main)
        noteListCollectionView?.register(
            noteCellNib,
            forCellWithReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier
        )
    }
}

// MARK: - Create Layout for Collection View
extension NoteListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

// MARK: - Configure Hierarchy and Data Source of Collection View
extension NoteListViewController {
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
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier,
                for: indexPath
            ) as? NoteCollectionViewListCell
            
            cell?.configure(with: note)
            return cell
        }
    }
    
    private func applyInitialSnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections(sections)
        snapshot.appendItems(notes)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Configure Navigation Bar and Relevant Actions
extension NoteListViewController {
    private func configureNavigationBar() {
        navigationItem.title = NavigationBarItems.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: NavigationBarItems.addButtonImage,
            target: self,
            action: #selector(addTapped)
        )
    }
    
    private func appendNewNote(to dataSource: UICollectionViewDiffableDataSource<Section, Note>) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([NoteData.newNoteConfiguration])
        notes.append(NoteData.newNoteConfiguration)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func insertNewNote(to dataSource: UICollectionViewDiffableDataSource<Section, Note>,
                               before firstItemInSnapshot: Note) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([NoteData.newNoteConfiguration], beforeItem: firstItemInSnapshot)
        notes.insert(NoteData.newNoteConfiguration, at: notes.startIndex)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addTapped() {
        guard let dataSource = dataSource else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.dataSourceNotSet.localizedDescription)
            return
        }
        
        let snapshot = dataSource.snapshot()
        
        if let firstItemInSnapshot = snapshot.itemIdentifiers.first {
            insertNewNote(to: dataSource, before: firstItemInSnapshot)
        } else {
            appendNewNote(to: dataSource)
        }
    }
}

// MARK: - Collection View Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noteSplitViewControllerDelegate?.showNote(with: notes[indexPath.item])
    }
}
