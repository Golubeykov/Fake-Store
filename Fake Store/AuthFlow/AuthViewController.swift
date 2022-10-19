//
//  AuthViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 19.10.2022.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var loginUnderline: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordUnderline: UIView!
    @IBOutlet private weak var loginButtonLabel: UIButton!

    // MARK: - Views

    private let showHidePasswordButton = UIButton(type: .custom)

    // MARK: - Properties

    private let loginLabelText = "Вход"
    private let loginTextFieldPlaceholder = "Логин"
    private let passwordTextFieldPlaceholder = "Пароль"
    private let textFieldPadding: CGFloat = 18
    private var loginButtonLabelText: NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: ColorsStorage.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let string = NSAttributedString(string: "Войти", attributes: attributes)
        return string
    }
    private let  myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    // MARK: - Action

    @IBAction func loginButtonAction(_ sender: Any) {
    }


}

// MARK: - Private methods

private extension AuthViewController {

    func configureAppearance() {
        configureViewBackground()
        configureLoginLabel()
        configureLoginTextField()
        configureLoginUnderline()
        configurePasswordTextField()
        configurePasswordUnderline()
        configureLoginButton()
    }

    func configureViewBackground() {
        view.backgroundColor = ColorsStorage.backgroundBlue
    }

    func configureLoginLabel() {
        loginLabel.text = loginLabelText
        loginLabel.font = .systemFont(ofSize: 26, weight: .bold)
        loginLabel.textColor = ColorsStorage.black
    }

    func configureLoginTextField() {
        loginTextField.placeholder = loginTextFieldPlaceholder
        loginTextField.backgroundColor = ColorsStorage.backgroundGray
        loginTextField.setLeftPaddingPoints(textFieldPadding)
    }

    func configureLoginUnderline() {
        loginUnderline.backgroundColor = ColorsStorage.black
    }

    func configurePasswordTextField() {
        passwordTextField.placeholder = passwordTextFieldPlaceholder
        passwordTextField.backgroundColor = ColorsStorage.backgroundGray
        passwordTextField.setLeftPaddingPoints(textFieldPadding)
        passwordTextField.textContentType = .password
    }

    func configurePasswordUnderline() {
        loginUnderline.backgroundColor = ColorsStorage.black
    }

    func configureLoginButton() {
        loginButtonLabel.backgroundColor = ColorsStorage.orange
        loginButtonLabel.setAttributedTitle(loginButtonLabelText, for: .normal)
        loginButtonLabel.tintColor = ColorsStorage.black
    }

}

//MARK: - Configuring password field

private extension AuthViewController {


    func enablePasswordToggle(){
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = ColorsStorage.clear
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -16, bottom: 0, trailing: 0)

        showHidePasswordButton.configuration = buttonConfiguration
        showHidePasswordButton.setImage(ImagesStorage.hiddenPasswordIcon, for: .normal)
        showHidePasswordButton.setImage(ImagesStorage.shownPasswordIcon, for: .selected)
        showHidePasswordButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        passwordTextField.rightView = showHidePasswordButton
        passwordTextField.rightViewMode = .always
        showHidePasswordButton.alpha = 0.4
    }

    @objc func togglePasswordView(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        showHidePasswordButton.isSelected.toggle()
    }
}
