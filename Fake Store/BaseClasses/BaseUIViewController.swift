//
//  BaseUIViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 20.10.2022.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    // MARK: - Properties
    private var isDarkContentBackground = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        isDarkContentBackground ? .lightContent : .darkContent
    }
    
    // MARK: - Private methods
    private func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setNavigationAppearanceForAllStates(_ appearance: UINavigationBarAppearance) {
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Methods
    func configureNavigationBar(title: String, backgroundColor: UIColor, titleColor: UIColor, isStatusBarDark: Bool) {
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: titleColor]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.tintColor = titleColor
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = title
        isStatusBarDark ? statusBarEnterDarkBackground() : statusBarEnterLightBackground()
    }
    
}
