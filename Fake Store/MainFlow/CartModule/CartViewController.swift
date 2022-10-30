//
//  CartViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 29.10.2022.
//

import UIKit

final class CartViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var makeOrderButtonLabel: UIButton!

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

    @IBAction func makeOrderButtonAction(_ sender: Any) {
    }

}

// MARK: - Private extension

private extension CartViewController {

    func configureAppearance() {
        configureButton()
        configureTableView()
        setGradientBackground()
    }

    func configureNavigationBar() {
        navigationItem.title = "Корзина"
    }

    func configureTableView() {
        cartTableView.backgroundColor = ColorsStorage.clear
    }

    func configureButton() {
        makeOrderButtonLabel.backgroundColor = ColorsStorage.orange
        makeOrderButtonLabel.setTitle("Сделать заказ", for: .normal)
        makeOrderButtonLabel.tintColor = ColorsStorage.black
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
