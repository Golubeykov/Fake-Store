//
//  AuthViewController.swift
//  Fake Store
//
//  Created by Антон Голубейков on 19.10.2022.
//

import UIKit

final class AuthViewController: BaseUIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var loginUnderline: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordUnderline: UIView!
    @IBOutlet private weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonConstraint: NSLayoutConstraint!
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
        configureNavigationBarStyle()
        subcribeToNotificationCenter()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotificationCenter()
    }

    // MARK: - Action

    @IBAction func loginButtonAction(_ sender: Any) {
        if loginTextField.text == "" {
            showEmptyLoginNotification()
        }
        if passwordTextField.text == "" {
            showEmptyPasswordNotification()
        }
        if (!(loginTextField.text == "") && !(passwordTextField.text == "")), let username = loginTextField.text, let password = passwordTextField.text {
            let buttonActivityIndicator = ButtonActivityIndicator(button: loginButtonLabel, originalButtonText: "Войти")
            buttonActivityIndicator.showButtonLoading()

            let credentials = AuthRequestModel(username: username, password: password)
            AuthService()
                .performLoginRequestAndSaveToken(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                let mainViewController = TabBarConfigurator().configure()
                                delegate.window?.rootViewController = mainViewController
                            }
                        }
                    case .failure (let error):
                        DispatchQueue.main.async {
                            var snackbarText = "Что-то пошло не так"

                            if let currentError = error as? PossibleErrors {
                                switch currentError {
                                case .nonAuthorizedAccess:
                                    snackbarText = "Логин или пароль введен неправильно"
                                case .noNetworkConnection:
                                    snackbarText = "Отсутствует интернет соединение"
                                default:
                                    snackbarText = "Что-то пошло не так"
                                }
                            }
                            guard let `self` = self else { return }
                            let model = SnackbarModel(text: snackbarText)
                            let snackbar = SnackbarView(model: model, viewController: self)
                            snackbar.showSnackBar()
                            buttonActivityIndicator.hideButtonLoading()
                        }
                    }
                }
        }
    }

    @IBAction func demoLogin(_ sender: Any) {
        loginTextField.text = "mor_2314"
        passwordTextField.text = "83r5^_"
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
        enablePasswordToggle()
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
        loginTextField.delegate = self
    }

    func configureLoginUnderline() {
        loginUnderline.backgroundColor = ColorsStorage.black
    }

    func configurePasswordTextField() {
        passwordTextField.placeholder = passwordTextFieldPlaceholder
        passwordTextField.backgroundColor = ColorsStorage.backgroundGray
        passwordTextField.setLeftPaddingPoints(textFieldPadding)
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
    }

    func configurePasswordUnderline() {
        loginUnderline.backgroundColor = ColorsStorage.black
    }

    func configureLoginButton() {
        loginButtonLabel.backgroundColor = ColorsStorage.orange
        loginButtonLabel.setTitle("Войти", for: .normal)
        loginButtonLabel.tintColor = ColorsStorage.black
    }

    func configureNavigationBarStyle() {
        configureNavigationBar(title: "", backgroundColor: ColorsStorage.clear, titleColor: ColorsStorage.clear, isStatusBarDark: false)
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

//MARK: - Handle empty text fields

extension AuthViewController: UITextFieldDelegate {
    func showEmptyLoginNotification() {
        loginUnderline.backgroundColor = ColorsStorage.red

        let loginEmptyNotification = UILabel(frame: CGRect(x: 0, y: 0, width: loginTextField.frame.width, height: 16))
        loginEmptyNotification.textAlignment = .left
        loginEmptyNotification.text = "Поле не может быть пустым"
        loginEmptyNotification.font = .systemFont(ofSize: 12)
        loginEmptyNotification.textColor = ColorsStorage.red
        loginEmptyNotification.tag = 100
        self.view.addSubview(loginEmptyNotification)
        loginEmptyNotification.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginEmptyNotification.rightAnchor.constraint(equalTo: loginTextField.rightAnchor)
        ])
        NSLayoutConstraint(item: loginEmptyNotification, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 32.0).isActive = true
        NSLayoutConstraint(item: loginEmptyNotification, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginTextField, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8.0).isActive = true
        passwordConstraint.constant = 46
        self.view.layoutIfNeeded()
    }
    func showEmptyPasswordNotification() {
        passwordUnderline.backgroundColor = ColorsStorage.red
        let passwordEmptyNotification = UILabel(frame: CGRect(x: 0, y: 0, width: loginTextField.frame.width, height: 16))
        passwordEmptyNotification.textAlignment = .left
        passwordEmptyNotification.text = "Поле не может быть пустым"
        passwordEmptyNotification.font = .systemFont(ofSize: 12)
        passwordEmptyNotification.textColor = ColorsStorage.red
        passwordEmptyNotification.tag = 150
        self.view.addSubview(passwordEmptyNotification)
        passwordEmptyNotification.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordEmptyNotification.rightAnchor.constraint(equalTo: loginTextField.rightAnchor)
        ])
        NSLayoutConstraint(item: passwordEmptyNotification, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 32.0).isActive = true
        NSLayoutConstraint(item: passwordEmptyNotification, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: passwordTextField, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8.0).isActive = true
        buttonConstraint.constant = 46
        self.view.layoutIfNeeded()
    }

    func dismissEmptyFieldsNotidication() {
        loginUnderline.backgroundColor = ColorsStorage.black
        passwordUnderline.backgroundColor = ColorsStorage.black
        if let emptyLoginNotificationLabel = self.view.viewWithTag(100) {
            emptyLoginNotificationLabel.removeFromSuperview()
        }
        if let emptyPasswordNotificationLabel = self.view.viewWithTag(150) {
            emptyPasswordNotificationLabel.removeFromSuperview()
        }
        passwordConstraint.constant = 26
        buttonConstraint.constant = 26
        self.view.layoutIfNeeded()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dismissEmptyFieldsNotidication()
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
