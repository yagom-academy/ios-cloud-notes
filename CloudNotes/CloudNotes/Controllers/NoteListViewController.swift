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
    @discardableResult
    func loadNotes(from assetName: String) -> Result<[Note], DataError> {
        guard let noteData = NSDataAsset(name: assetName)?.data else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.cannotFindFile.localizedDescription)
            return .failure(DataError.cannotFindFile)
        }
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase,
                                  dateDecodingStrategy: .secondsSince1970)
        guard let decoded = try? decoder.decode([Note].self, from: noteData) else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.decodingFailed.localizedDescription)
            return .failure(DataError.decodingFailed)
        }
        notes = decoded

        return .success(notes)
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
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
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
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension NoteListViewController: UICollectionViewDelegate { }
