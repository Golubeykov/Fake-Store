//
//  AppDelegate.swift
//  Fake Store
//
//  Created by Антон Голубейков on 26.09.2022.
//

import UIKit

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
        DispatchQueue.main.async {
            self.window?.rootViewController = TabBarConfigurator().configure()
        }
    }
}

