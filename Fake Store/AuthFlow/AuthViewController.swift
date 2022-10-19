//
//  AuthViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 19.10.2022.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var scrollView: UIScrollView!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subcribeToNotificationCenter()
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
        hideKeyboardWhenTapped()
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

//MARK: - Handle keyboard's show-up methods

extension AuthViewController {
    //Скрытие клавиатуры по тапу
    func hideKeyboardWhenTapped() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    func subcribeToNotificationCenter() {
        //Подписываемся на два уведомления: одно приходит при появлении клавиатуры. #selector(self.keyboardWasShown) - функция, которая выполняется после получения события.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //Функции, которые вызываются после появления / исчезновения клавиатуры (нужно чтобы клавиатура не залезала на поля ввода)
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets

    }
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем все Insets в ноль
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }


}
