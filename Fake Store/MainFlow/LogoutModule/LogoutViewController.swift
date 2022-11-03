//
//  LogoutViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 03.11.2022.
//

import UIKit

final class LogoutViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var logoutButtonLabel: UIButton!

    // MARK: - Properties

    var tokenStorage: TokenStorage {
        BaseTokenStorage()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    // MARK: - Actions

    @IBAction func logoutButtonAction(_ sender: Any) {
        do {
            try tokenStorage.removeTokenFromContainer()
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                let authViewController = AuthViewController()
                let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
                delegate.window?.rootViewController = navigationAuthViewController
            }
        } catch {
            appendConfirmingAlertView(for: self, text: "Ошибка выхода", completion: {_ in})
        }
    }

    // MARK: - Private methods

    private func configureAppearance() {
        configureButton()
        setGradientBackground()
    }

    func configureNavigationBar() {
        navigationItem.title = "Профиль"
    }

    func configureButton() {
        logoutButtonLabel.backgroundColor = ColorsStorage.orange
        logoutButtonLabel.setTitle("Выйти", for: .normal)
        logoutButtonLabel.tintColor = ColorsStorage.black
    }

    func setGradientBackground() {
        let colorTop = ColorsStorage.white.cgColor
        let colorBottom = ColorsStorage.gradientBlue.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
