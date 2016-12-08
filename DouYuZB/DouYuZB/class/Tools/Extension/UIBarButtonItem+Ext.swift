//
//  UIBarButtonItem+Ext.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    //类方法也可以，但是swift更为推荐构造函数
    class func createItem(imageName: String, highImageName: String, size: CGSize) ->UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: [])
         btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: .zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
    
    //遍历构造函数  1.必须以convenience开头  2.在构造函数中必须明确一个设计的构造函数（self）
    //1.
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: [])
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: .zero, size: size)
        }

        //2.
        self.init(customView:btn)
    }
    
}
