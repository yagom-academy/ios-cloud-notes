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
        configurePostNotification()
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

        noteListViewController.noteData = data
        detailedNoteViewController.noteData = dataSourceProvider?.noteList.first
        detailedNoteViewController.index = 0
    }

    // MARK: - Configure Notification

    func configurePostNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(passNote(notification:)),
                                               name: NSNotification.Name("NoteListSelected"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(passModifiedNote(notification:)),
                                               name: NSNotification.Name("NoteModified"),
                                               object: nil)
    }

    @objc
    func passNote(notification: Notification) {
        guard let index = notification.object as? Int else {
            return
        }

        detailedNoteViewController.noteData = dataSourceProvider?.noteList[index]
        detailedNoteViewController.index = index
    }

    @objc
    func passModifiedNote(notification: Notification) {
        guard let noteData = notification.object as? (index: Int, note: Note) else {
            return
        }
        noteListViewController.noteData[noteData.index] = noteData.note
    }
}
