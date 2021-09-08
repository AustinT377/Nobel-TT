//
//  Extensions.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/21/20.
//

import Foundation
import UIKit


extension UIViewController {
    func startLoading(message: String = "Loading") {
        self.view.isUserInteractionEnabled = false
        LoadingIndicatorView.show(self.view, loadingText: message)
    }
    
    @objc func stopLoading() {
        self.view.isUserInteractionEnabled = true
        LoadingIndicatorView.hide()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

