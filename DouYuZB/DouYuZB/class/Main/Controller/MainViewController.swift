//
//  MainViewController.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        let vc = UIViewController()
//        addChildViewController(vc)
        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Profile")
        
    }

    private func addChildVC(storyName: String){
        //1.通过sb创建控制器  nil表示mainBundle  强制解包
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        //2.添加控制器
        addChildViewController(childVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
