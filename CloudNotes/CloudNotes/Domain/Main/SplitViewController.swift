import UIKit

class SplitViewController: UISplitViewController {
    private let noteListViewController = NoteListViewController()
    private let detailedNoteViewController = DetailedNoteViewController()
    private var dataSourceProvider: NoteDataSource?

    private var currentNoteIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSourceProvider = CDDataSourceProvider()
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        self.setViewController(noteListViewController, for: .primary)
        self.setViewController(detailedNoteViewController, for: .secondary)
        fetchNotes()

        noteListViewController.setDelegate(delegate: self)
        detailedNoteViewController.setDelegate(delegate: self)
    }

    private func fetchNotes() {
        do {
            try dataSourceProvider?.fetch()
        } catch {
            print(error.localizedDescription)
        }

        passInitialData()
    }

    private func passInitialData() {
        guard let data = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.setNoteListData(data)
        detailedNoteViewController.setNoteData(data.first)
        self.currentNoteIndex = 0
    }
}

// MARK: - Note Data Source Delegate

extension SplitViewController: NoteListViewDelegate {
    func deleteNote(_ note: Content) {
        do {
            try dataSourceProvider?.deleteNote(note)
        } catch {
            print(error)
        }
        guard let noteList = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.setNoteListData(noteList)
        detailedNoteViewController.setNoteData(noteList.first)
    }

    func creatNote() {
        let note = Content(title: "", body: "", lastModifiedDate: Date().timeIntervalSince1970, identification: UUID())
        do {
            try dataSourceProvider?.createNote(note)
        } catch let error {
            print(error)
        }
        guard let noteList = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.setNoteListData(noteList)
        detailedNoteViewController.setNoteData(note)
    }

    func passNote(index: Int) {
        self.currentNoteIndex = index
        detailedNoteViewController.setNoteData(dataSourceProvider?.noteList[index])
    }
}

extension SplitViewController: DetailedNoteViewDelegate {
    func passModifiedNote(note: Content) {
        do {
            try dataSourceProvider?.updateNote(note)
        } catch let error {
            print(error)
        }
        noteListViewController.setNoteListData(dataSourceProvider!.noteList)
    }
}
