//
//  AppDelegate.swift
//  Demo
//
//  Created by Lin on 2023/12/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //初始化
        window = UIWindow()
        
        
        window?.rootViewController = ViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

