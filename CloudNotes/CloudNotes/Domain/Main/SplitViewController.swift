import UIKit
import SwiftyDropbox

class SplitViewController: UISplitViewController {
    private let noteListViewController = NoteListViewController()
    private let detailedNoteViewController = DetailedNoteViewController()
    private var dataSourceProvider: NoteDataSource?
    private var currentNoteIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSourceProvider = CDDataSourceProvider()
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        self.setViewController(noteListViewController, for: .primary)
        self.setViewController(detailedNoteViewController, for: .secondary)
        self.fetchNotes()

        self.noteListViewController.setDelegate(delegate: self)
        self.detailedNoteViewController.setDelegate(delegate: self)
    }

    private func fetchNotes() {
        do {
            try dataSourceProvider?.fetch()
        } catch {
            print(error.localizedDescription)
        }

        self.passInitialData()
    }

    private func passInitialData() {
        guard let data = dataSourceProvider?.noteList else {
            return
        }

        self.noteListViewController.setNoteList(data)
        self.detailedNoteViewController.setNoteData(data.first)
        self.currentNoteIndex = 0
    }
}

// MARK: - NoteList View Delegate
extension SplitViewController: NoteListViewDelegate {
    func deleteNote(_ note: Content, index: Int) {
        do {
            try self.dataSourceProvider?.deleteNote(note)
        } catch {
            print(error)
        }

        guard let noteList = self.dataSourceProvider?.noteList else {
            return
        }

        self.noteListViewController.delete(at: index)
        var changedIndex: Int
        if noteList.count == index {
            changedIndex = index - 1
        } else {
            changedIndex = index
        }

        self.noteListViewController.selectedIndexPath = IndexPath(row: changedIndex, section: 0)
        self.detailedNoteViewController.setNoteData(noteList[safe: changedIndex])
    }

    func creatNote() {
        let note = Content(
            title: "",
            body: "",
            lastModifiedDate: Date().timeIntervalSince1970,
            identification: UUID()
        )
        do {
            try dataSourceProvider?.createNote(note)
        } catch let error {
            print(error)
        }

        guard let note = dataSourceProvider?.noteList.first else {
            return
        }

        noteListViewController.insert(note)
        noteListViewController.selectedIndexPath = IndexPath(row: 0, section: 0)

        detailedNoteViewController.setNoteData(note)
    }

    func passNote(at index: Int) {
        self.currentNoteIndex = index
        detailedNoteViewController.setNoteData(dataSourceProvider?.noteList[index])
        self.view.endEditing(true)
    }
}

// MARK: - DetailedNote View Delegate

extension SplitViewController: DetailedNoteViewDelegate {
    func deleteNote(_ note: Content) {
        do {
            try dataSourceProvider?.deleteNote(note)
        } catch {
            print(error)
        }

        guard let noteList = dataSourceProvider?.noteList else {
            return
        }

        guard let index = self.currentNoteIndex else {
            return
        }

        noteListViewController.delete(at: index)
        detailedNoteViewController.setNoteData(noteList.first)
    }

    func passModifiedNote(_ note: Content) {
        do {
            try dataSourceProvider?.updateNote(note)
        } catch let error {
            print(error)
        }

        guard let noteList = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.setNoteList(noteList)
    }
}

// MARK: - Array Extension

private extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
