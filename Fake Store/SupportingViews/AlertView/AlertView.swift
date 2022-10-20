//
//  AlertView.swift
//  Fake Store
//
//  Created by Антон Голубейков on 20.10.2022.
//

import UIKit

func appendConfirmingAlertView(for viewController: UIViewController, text: String, completion: @escaping (UIAlertAction) -> Void) {
    let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: UIAlertController.Style.alert)
    let confirmAction = UIAlertAction(title: "Да, точно", style: UIAlertAction.Style.default, handler: completion)
    let cancelAction = UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    alert.preferredAction = confirmAction

    viewController.present(alert, animated: true, completion: nil)
}
