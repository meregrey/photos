//
//  PhotoListViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit

final class PhotoListViewController: UIViewController {
    private let viewModel = PhotoListViewModel()
    
    private var isLoading = false
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let destination = segue.destination as? PhotoDetailViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let photo = viewModel.photoList.value.photos[indexPath.row]
        guard let photoViewModel = PhotoViewModel(photo: photo) else { return }
        destination.viewModel = photoViewModel
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.photoList.bind { [weak self] photoList in
            Task { @MainActor in
                let indexPaths = photoList.latestRange.map { IndexPath(row: $0, section: 0) }
                self?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            Task { @MainActor in
                guard let indexPath = self?.tableView.indexPathsForVisibleRows?.filter({ $0.section == 1 }).first else { return }
                guard let loadingCell = self?.tableView.cellForRow(at: indexPath) as? LoadingCell else { return }
                loadingCell.animate(isLoading)
                self?.isLoading = isLoading
            }
        }
    }
    
    private func fetchPhotos() {
        Task {
            do {
                try await viewModel.fetchPhotos()
            } catch {
                displayAlert(with: error)
            }
        }
    }
    
    @MainActor
    private func displayAlert(with error: Error) {
        let message = (error as? LoadingError)?.localizedDescription ?? error.localizedDescription
        displayAlert(message: message)
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

extension PhotoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.photoList.value.photos.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: PhotoListCell = tableView.dequeueReusableCell(for: indexPath)
            let photo = viewModel.photoList.value.photos[indexPath.row]
            guard let photoViewModel = PhotoViewModel(photo: photo) else { return cell }
            cell.configure(with: photoViewModel)
            return cell
        } else {
            let cell: LoadingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.animate(isLoading)
            return cell
        }
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let previousRowOfLast = tableView.numberOfRows(inSection: 0) - 2
        if indexPath.row == previousRowOfLast { fetchPhotos() }
    }
}
