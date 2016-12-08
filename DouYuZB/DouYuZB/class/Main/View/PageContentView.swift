//
//  PageContentView.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    /// MARK:- 定义属性
    var childVcs: [UIViewController]
    
    //这里面要注意循环引用
    //weak只能修饰可选类型
   weak var parentViewController: UIViewController?
    
    //MARK:-懒加载属性
    //闭包中使用self，要用[weak self] in
    lazy var collectionView: UICollectionView = {[weak self] in
        //1.创建layout 
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        //2.创建collectionView
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    
    //MARK:-自定义构造函数
    init(frame: CGRect,childVcs: [UIViewController], parentViewController: UIViewController?) {
        //设置属性写在super之前
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 设置界面
extension PageContentView{
    func setupUI(){
        //1.将所有的子控制器添加到父控制器中
        for childVc in childVcs{
            parentViewController?.addChildViewController(childVc)
        }
        //2.添加UICollectionView，用于在cell上存放控制器的view
        addSubview(collectionView)
    }
}

extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //2.给cell设置内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.frame
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
}


// MARK: - 对外暴露的方法，Home中PageTitleView的代理方法调用
extension PageContentView{
    func setCurrentIndex(currentIndex: Int){
        let offSetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: false)
    }
}
