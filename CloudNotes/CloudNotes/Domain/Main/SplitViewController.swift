import UIKit
import SwiftyDropbox

class SplitViewController: UISplitViewController {
    private let noteListViewController = NoteListViewController()
    private let detailedNoteViewController = DetailedNoteViewController()
    private var dataSourceProvider: NoteDataSource?
    private var currentNoteIndex: Int?
    private var synchronizationProvider: Synchronizable?
    var timer: Timer?

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.alpha = 0.3
        view.isHidden = true
        view.frame = self.view.frame
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSourceProvider = CDDataSourceProvider()
        self.synchronizationProvider = DropboxProvider()
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        self.setViewController(noteListViewController, for: .primary)
        self.setViewController(detailedNoteViewController, for: .secondary)
        self.fetchNotes()

        self.noteListViewController.setDelegate(delegate: self)
        self.detailedNoteViewController.setDelegate(delegate: self)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(dimView)
        configureConstraint()
        setUploadTimer()
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
        self.noteListViewController.selectedIndexPath = IndexPath(row: 0, section: 0)
        self.detailedNoteViewController.setNoteData(data.first)
        self.currentNoteIndex = 0
    }

    // MARK: - View Configure
    func configureConstraint() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Synchronization Method
    
    @objc func upload() {
        self.synchronizationProvider?.upload { error in
            if error != nil {
                self.noteListViewController.presentUploadFailureAlert()
                self.noteListViewController
            }
        }
    }

    func download() {
        activityIndicator.startAnimating()
        self.dimView.isHidden = false
        self.synchronizationProvider?.download { error in
            if error == nil {
                self.fetchNotes()
            } else {
                self.noteListViewController.presentDownloadFailureAlert()
            }
            self.activityIndicator.stopAnimating()
            self.dimView.isHidden = true
        }
    }

    func setUploadTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 15,
            target: self,
            selector: #selector(upload),
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: - NoteList View Delegate

extension SplitViewController: NoteListViewDelegate {
    func logIn() {
        self.synchronizationProvider?.logIn(at: noteListViewController)
    }

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
