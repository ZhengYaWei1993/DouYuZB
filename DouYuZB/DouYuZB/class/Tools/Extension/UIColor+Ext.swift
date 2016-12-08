//
//  UIColor+Ext.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b:CGFloat, alpha: CGFloat) {
        
        self.init(red:r/255.0, green: g/255.0, blue:b/255.0, alpha:1.0)
        //UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    }
}
