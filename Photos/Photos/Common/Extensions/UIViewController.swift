//
//  UIViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit

extension UIViewController {
    func displayAlert(title: String = Alert.Title.errorOccurred,
                      message: String? = nil,
                      actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: Alert.ActionTitle.ok, style: .default)
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(defaultAction)
        }
        present(alert, animated: true)
    }
}
