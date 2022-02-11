import UIKit

class SplitViewController: UISplitViewController {
    let noteListViewController = NoteListViewController()
    let detailedNoteViewController = DetailedNoteViewController()
    var dataSourceProvider: NoteDataSource?

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
        detailedNoteViewController.index = 0
    }
}

// MARK: - Note Data Source Delegate

extension SplitViewController: NoteListViewDelegate, DetailedNoteViewDelegate {
    func passNote(index: Int) {
        detailedNoteViewController.noteData = dataSourceProvider?.noteList[index]
        detailedNoteViewController.index = index
    }

    func passModifiedNote(note: Note, index: Int) {
        noteListViewController.noteListData[index] = note
    }
}
1
