//
//  AppDelegate.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/2.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //全局修改tabbarItem的颜色
        UITabBar.appearance().tintColor = UIColor.orange
        return true
    }

    

}

