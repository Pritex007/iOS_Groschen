//
// AppDelegate.swift
// Groschen
//
// Created by Ilya Murashko on 23.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let tabBarController = TabBarController()
        coordinator = AppCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        
        CoreDataManager.shared.loadStores()

        // TODO: Добавить Swinject, резолвить сервис из контейнера
        let analyticsConfigurator: AnalyticsConfiguratorProtocol = AnalyticsService()
        analyticsConfigurator.activateAnalytics()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
