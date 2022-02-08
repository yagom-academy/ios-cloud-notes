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
    }

    func fetchNotes() {
        do {
            try dataSourceProvider?.fetch()
        } catch {
            print(error.localizedDescription)
        }

        guard let data = dataSourceProvider?.noteList else {
            return
        }

        noteListViewController.noteData = data
    }
}
