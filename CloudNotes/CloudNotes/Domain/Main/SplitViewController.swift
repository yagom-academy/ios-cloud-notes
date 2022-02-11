import UIKit

class SplitViewController: UISplitViewController {
    let noteListViewController = NoteListViewController()
    let detailedNoteViewController = DetailedNoteViewController()
    var dataSourceProvider: NoteDataSource?

    var currentNoteIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSourceProvider = JSONDataSourceProvider()
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        self.setViewController(noteListViewController, for: .primary)
        self.setViewController(detailedNoteViewController, for: .secondary)
        fetchNotes()

        noteListViewController.setDelegate(delegate: self)
        detailedNoteViewController.setDelegate(delegate: self)
    }

    func fetchNotes() {
        do {
            try dataSourceProvider?.fetch()
        } catch {
            print(error.localizedDescription)
        }

        passInitialData()
    }

    func passInitialData() {
        guard let data = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.noteListData = data
        detailedNoteViewController.noteData = data.first
        self.currentNoteIndex = 0
    }
}

// MARK: - Note Data Source Delegate

extension SplitViewController: NoteListViewDelegate, DetailedNoteViewDelegate {
    func passNote(index: Int) {
        self.currentNoteIndex = index
        detailedNoteViewController.noteData = dataSourceProvider?.noteList[index]
    }

    func passModifiedNote(note: Note) {
        guard let index = self.currentNoteIndex else {
            return
        }

        noteListViewController.noteListData[index] = note
    }
}
