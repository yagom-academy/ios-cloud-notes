import UIKit
import SwiftyDropbox

class SplitViewController: UISplitViewController {

    private let noteListViewController = NoteListViewController()
    private let detailedNoteViewController = DetailedNoteViewController()
    private var dataSourceProvider: NoteDataSource?
    private var currentNoteIndex: Int?
    private var synchronizationProvider: Synchronizable?
    private var timer: Timer?

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

// MARK: - Life Cycle Method(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpController()
    }

    private func setUpController() {
        self.setUpProvider()

        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile

        self.setViewController(self.noteListViewController, for: .primary)
        self.setViewController(self.detailedNoteViewController, for: .secondary)

        self.fetchNotes()

        self.setUpSubView()
        self.setUploadTimer()
    }

    private func setUpProvider() {
        self.dataSourceProvider = CDDataSourceProvider()
        self.synchronizationProvider = DropboxProvider()
    }

    private func setUpSubView() {
        self.noteListViewController.setDelegate(delegate: self)
        self.detailedNoteViewController.setDelegate(delegate: self)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.dimView)
        self.configureConstraint()
    }

    private func fetchNotes() {
        do {
            try self.dataSourceProvider?.fetch()
            self.passInitialData()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func passInitialData() {
        guard let data = dataSourceProvider?.noteList
        else {
            return
        }

        self.noteListViewController.setNoteList(data)
        self.noteListViewController.selectedIndexPath = IndexPath(row: 0, section: 0)
        self.detailedNoteViewController.setNoteData(data.first)
        self.currentNoteIndex = 0
    }

    // MARK: - View Configure

    private func configureConstraint() {
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    // MARK: - Synchronization Method

    @objc
    func upload() {
        guard let memos = self.dataSourceProvider?.noteList,
              let memosString = self.synchronizationProvider?.convertModelToText(from: memos)
        else {
            return
        }

        self.synchronizationProvider?.upload(memoString: memosString) { error in
            if error != nil {
                self.noteListViewController.presentUploadFailureAlert()
            }
        }
    }

    func download() {
        self.activityIndicator.startAnimating()
        self.dimView.isHidden = false
        self.synchronizationProvider?.download { result in
            switch result {
            case .success(let memos):
                try? self.dataSourceProvider?.deleteAllNote()
                memos.forEach { memo in
                    try? self.dataSourceProvider?.createNote(memo)
                }
                self.fetchNotes()

            case .failure:
                self.noteListViewController.presentDownloadFailureAlert()
            }
            self.activityIndicator.stopAnimating()
            self.dimView.isHidden = true
        }
    }

    private func setUploadTimer() {
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
            self.passDeletedNote(at: index)
        } catch {
            print(error)
        }
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
            self.passNewNote(note)
        } catch let error {
            print(error)
        }
    }

    func passNote(at index: Int) {
        self.currentNoteIndex = index
        self.detailedNoteViewController.setNoteData(dataSourceProvider?.noteList[index])
        self.view.endEditing(true)
    }

    func synchronizationLastUpdated() -> String? {
        self.synchronizationProvider?.lastUpdated()
    }

    private func passDeletedNote(at index: Int) {
        guard let noteList = self.dataSourceProvider?.noteList else {
            return
        }

        self.noteListViewController.delete(at: index)
        let changedIndex = noteList.count == index ? index - 1 : index

        self.noteListViewController.selectedIndexPath = IndexPath(row: changedIndex, section: 0)
        self.detailedNoteViewController.setNoteData(noteList[safe: changedIndex])
    }

    private func passNewNote(_ note: Content) {
        guard let note = self.dataSourceProvider?.noteList.first else {
            return
        }

        self.noteListViewController.insert(note)
        self.noteListViewController.selectedIndexPath = IndexPath(row: 0, section: 0)

        self.detailedNoteViewController.setNoteData(note)
    }
}

// MARK: - DetailedNote View Delegate

extension SplitViewController: DetailedNoteViewDelegate {

    func deleteNote(_ note: Content) {
        do {
            try dataSourceProvider?.deleteNote(note)
            self.passDeletedNote()
        } catch {
            print(error)
        }
    }

    func passModifiedNote(_ note: Content) {
        do {
            try self.dataSourceProvider?.updateNote(note)

            guard let noteList = self.dataSourceProvider?.noteList
            else {
                return
            }

            self.noteListViewController.setNoteList(noteList)
        } catch let error {
            print(error)
        }
    }

    private func passDeletedNote() {
        guard let noteList = self.dataSourceProvider?.noteList,
              let index = self.currentNoteIndex
        else {
            return
        }

        self.noteListViewController.delete(at: index)
        self.detailedNoteViewController.setNoteData(noteList.first)
    }
}

// MARK: - Array Extension

private extension Array {

    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
