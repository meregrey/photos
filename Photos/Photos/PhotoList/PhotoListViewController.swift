//
//  PhotoListViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit

final class PhotoListViewController: UIViewController {
    private let viewModel = PhotoListViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
        fetchPhotos()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.photoList.bind { [weak self] photoList in
            DispatchQueue.main.async {
                let indexPaths = photoList.latestRange.map { IndexPath(row: $0, section: 0) }
                self?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    private func fetchPhotos() {
        viewModel.fetchPhotos { [weak self] error in
            DispatchQueue.main.async {
                self?.displayAlert(message: error.message)
            }
        }
    }
}

extension PhotoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photoList.value.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoListCell = tableView.dequeueReusableCell(for: indexPath)
        let photo = viewModel.photoList.value.photos[indexPath.row]
        guard let photoViewModel = PhotoViewModel(photo: photo) else { return cell }
        cell.configure(with: photoViewModel)
        return cell
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let previousRowOfLast = tableView.numberOfRows(inSection: 0) - 2
        if indexPath.row == previousRowOfLast { fetchPhotos() }
    }
}
