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
    
    // MARK: - Section for diffable data source
    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Namespaces
    enum NoteData {
        static let sampleFileName = "sample"
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes(from: NoteData.sampleFileName)
        configureHierarchy()
        registerCellNib()
        configureDataSource()
        applyInitialSnapshot()
    }
}

// MARK: - Load Notes from Sample JSON
extension NoteListViewController {
    func loadNotes(from assetName: String) {
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
        noteListCollectionView?.register(noteCellNib,
                                         forCellWithReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier)
    }
}

// MARK: - Create Layout for Collection View
extension NoteListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

// MARK: - Configure Hierarchy and Data Source for Collection View
extension NoteListViewController {
    private func configureHierarchy() {
        noteListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let noteListCollectionView = noteListCollectionView else {
            os_log(.fault,
                   log: .ui,
                   OSLog.objectCFormatSpecifier,
                   UIError.collectionViewNotSet.localizedDescription)
            return
        }
        
        noteListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(noteListCollectionView)
        noteListCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        guard let noteListCollectionView = noteListCollectionView else {
            os_log(.fault,
                   log: .ui,
                   OSLog.objectCFormatSpecifier,
                   UIError.collectionViewNotSet.localizedDescription)
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

// MARK: - Collection View Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let noteDetailViewController = splitViewController?.viewController(
                for: .secondary
        ) as? NoteDetailViewController else {
            os_log(.error,
                   log: .ui,
                   OSLog.objectCFormatSpecifier,
                   UIError.downcastingFailed("Secondary view controller", #function).localizedDescription)
            return
        }
        
        noteDetailViewController.setContent(with: notes[indexPath.item])
        noteDetailViewController.updateUI()
        noteDetailViewController.noteTextView.resignFirstResponder()
        
        splitViewController?.showDetailViewController(noteDetailViewController, sender: nil)
    }
}
