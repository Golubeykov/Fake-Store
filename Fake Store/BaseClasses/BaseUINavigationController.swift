//
//  BaseUINavigationController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 20.10.2022.
//

import UIKit

class BaseUINavigationController: UINavigationController {

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        viewControllers.first?.preferredStatusBarStyle ?? .lightContent
    }

}
