//
//  PhotoListCell.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit

final class PhotoListCell: UITableViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    func configure(with viewModel: PhotoViewModel) {
        photoImageView.image = viewModel.image
        userNameLabel.text = viewModel.userName
    }
}
