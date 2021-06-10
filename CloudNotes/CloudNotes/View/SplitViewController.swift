//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit
// @@delegate : @@의 이벤트를 받아서 내가 처리하겠다!
class SplitViewController: UISplitViewController {
    private var memoListViewController: MemoListViewController?
    private var memoDetailViewController: MemoDetailViewController?

    weak var memoListViewDelegate: MemoListViewDelegate?
    weak var memoDetailViewDelegate: MemoDetailViewDelegate?

    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemoListViewController()
        setUpMemoDetailViewController()
        setUpSplitViewController()
        setUpLoadingIndicator()
        setUpMemoManager()
    }

    private func setUpMemoListViewController() {
        memoListViewController = MemoListViewController()
        memoListViewController?.memoListViewDelegate = self
    }

    private func setUpMemoDetailViewController() {
        memoDetailViewController = MemoDetailViewController()
        memoDetailViewController?.memoDetailViewDelegate = self
    }

    private func setUpSplitViewController() {
        guard let memoListViewController = memoListViewController,
              let memoDetailViewController = memoDetailViewController else { return }
        delegate = self
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        viewControllers = [
            memoListViewController,
            memoDetailViewController
        ]
    }

    private func setUpLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
    }

    private func setUpMemoManager() {
        MemoManager.shared.memoManagerDelegate = self
        MemoManager.shared.fetchMemoData(completionHandler: fetchMemoDataCompletionHandler(result:))
    }

    private func fetchMemoDataCompletionHandler(result: Result<Any?, CoreDataError>) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
            self.memoListViewController?.reloadMemoListTableViewData()
        case .failure(let error):
            self.loadingIndicator.stopAnimating()
            showAlert(alert: UIAlertController(title: "에러 발생", message: error.errorDescription,
                                               preferredStyle: .alert))
        }
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - MemoListViewDelegate, MemoDetailViewDelegate

extension SplitViewController: MemoListViewDelegate, MemoDetailViewDelegate {
    func memoAddButtonDidTapped() {
        MemoManager.shared.createMemo()
    }

    func memoTitleTextViewDidChanged(memoIndexPathToUpdate: IndexPath, text: String) {
        MemoManager.shared.updateMemoTitle(indexPath: memoIndexPathToUpdate, text: text)
    }

    func memoDescriptionTextViewDidChanged(memoIndexPathToUpdate: IndexPath, text: String) {
        MemoManager.shared.updateMemoDescription(indexPath: memoIndexPathToUpdate, text: text)
    }

    func memoDeleteButtonDidTapped(memoIndexPath: IndexPath) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
            MemoManager.shared.deleteMemo(indexPath: memoIndexPath)
        }
        let noAction = UIAlertAction(title: "아니오", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)

        showAlert(alert: alert)
    }

    func memoShareButtonDidTapped(memoIndexPathToShare: IndexPath, sourceView: UIView) {
        guard let memos = MemoManager.shared.memos else { return }

        let activityView = UIActivityViewController(activityItems: [memos[memoIndexPathToShare.row].title],
                                                    applicationActivities: nil)

        if UIDevice.current.userInterfaceIdiom == .pad {
            let popOverPresentationController = activityView.popoverPresentationController
            popOverPresentationController?.sourceView = sourceView
        }

        present(activityView, animated: true)
    }

    func showAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let selectedMemo = MemoManager.shared.memos?[indexPath.row],
              let memoDetailViewController = memoDetailViewController else { return }

        memoDetailViewController.setUpData(memo: selectedMemo, indexPath: indexPath)
        showDetailViewController(memoDetailViewController, sender: self)
    }
}

// MARK: - MemoManagerDelegate

extension SplitViewController: MemoManagerDelegate {
    func memoDidCreated(createdMemo: Memo, createdMemoIndexPath: IndexPath) {
        guard let memoListViewController = memoListViewController,
              let memoDetailViewController = memoDetailViewController else { return }

        memoListViewController.createNewCell()
        memoDetailViewController.setUpData(memo: createdMemo, indexPath: createdMemoIndexPath)

        showDetailViewController(memoDetailViewController, sender: self)
    }

    func memoDidUpdated(updatedMemoIndexPath: IndexPath) {
        memoListViewController?.updateCell(indexPath: updatedMemoIndexPath)
    }

    func memoDidDeleted(deletedMemoIndexPath: IndexPath) {
        memoListViewController?.deleteCell(indexPath: deletedMemoIndexPath)
        memoDetailViewController?.clearField()
    }
}
