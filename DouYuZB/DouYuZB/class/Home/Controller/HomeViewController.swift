//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit
private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    /*****************************************/
    //懒加载属性
    //通过闭包形式创建titleView
   lazy var pageTitleView : PageTitleView = {[weak self] in
        let frame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH , width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: frame, titles: titles)
        titleView.delegate = self
//        titleView.backgroundColor = UIColor.purple
        return titleView
    }()
    
    lazy var pageContentView: PageContentView = {[weak self] in
        //1.确定内容frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        //2.确定所有子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), alpha: 1)
            childVcs.append(vc)
        }
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        return pageContentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

}

// MARK: - 设置UI界面
extension HomeViewController{
    func setupUI(){
        /***************************************/
        //0.不需要调整UIScrollVIew的内边距
        //不写这句的话scrollView上的label不显示，因为scrollView的内部内容在有导航栏的时候会自动添加64的内边距，显示在scrollView的下面
        automaticallyAdjustsScrollViewInsets = false
        //设置导航栏
        setupNavigationBar()
        //添加titleView
        view.addSubview(pageTitleView)
        //添加pageContentView
        view.addSubview(pageContentView)
         pageContentView.backgroundColor = UIColor.purple
        
    }
    
    /// 设置导航栏
    private func setupNavigationBar(){
        //1.设置item
        let mySize = CGSize(width: 40, height: 40)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //***历史按钮
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: mySize)
        
        //***搜索按钮
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: mySize)
      
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: mySize)
        /******************************/
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}


// MARK: - PageTitleViewDelegate
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        //设置cillectionView的滚动位置
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}
