//
//  PhotoDetailViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/27.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    var viewModel: PhotoViewModel?
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureViews() {
        title = viewModel?.userName
        imageView.image = viewModel?.image
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = ""
    }
}
