//
//  AppDelegate.swift
//  Fake Store
//
//  Created by Антон Голубейков on 26.09.2022.
//

import UIKit

//just checking a new git cleint - Fork. 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: - UIApplication
    var window: UIWindow?
    let lauchScreenStoryBoard = UIStoryboard(name: "LaunchScreen", bundle: .main)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        startApplicationProcess()
        return true
    }
    
    //MARK: - Methods
    func startApplicationProcess() {
        runLaunchScreen()
        runMainFlow()
    }
    func runLaunchScreen() {
        let lauchScreenViewController = lauchScreenStoryBoard
            .instantiateInitialViewController()
        window?.rootViewController = lauchScreenViewController
    }
    func runMainFlow() {
        self.window?.rootViewController = TabBarConfigurator().configure()

        let creds = AuthRequestModel(username: "mor_2314", password: "83r5^_")
        let auth = AuthService()
        auth.performLoginRequestAndSaveToken(credentials: creds) { result in
            switch result {
            case .success:
                print("succes")
            case .failure:
                print("failure")
            }
        }
    }
}

