//
//  UIView.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit

extension UIView {
    static var identifier: String { String(describing: self) }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else { return T() }
        return cell
    }
}
