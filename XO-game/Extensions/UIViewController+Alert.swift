//
//  UIViewController+Alert.swift
//  XO-game
//
//  Created by Daniil Kniss on 17.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action =  UIAlertAction(title: "Ок", style: .default) { _ in
            completion?()
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true)
    }
}
