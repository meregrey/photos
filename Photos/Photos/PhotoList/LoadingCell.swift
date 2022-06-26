//
//  LoadingCell.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/25.
//

import UIKit

final class LoadingCell: UITableViewCell {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}
