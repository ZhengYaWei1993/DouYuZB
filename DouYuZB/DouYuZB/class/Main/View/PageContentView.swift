//
//  PageContentView.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contenView: PageContentView, progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    weak var delegate:PageContentViewDelegate?
    
    
    /// MARK:- 定义属性
    var childVcs: [UIViewController]
    
    /// 为了防止点击label时，先调用label的点击方法，然后scrollView滚动方法（这个是没有必要调用的），scrollView滚动进而又会调用pageTitleView对外公开的方法。所以用了这个属性进行判断
    var isForbidScrollDelegate: Bool = false
    /*************************/
    //用于保存滑动开始那一刻的偏移量，进而和滚动完成后的偏移量比较，判断是左滑动还是由华东
    var startOffsetX: CGFloat = 0
    
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
        collectionView.delegate = self
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

extension PageContentView:UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
   
        isForbidScrollDelegate = false
       
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否是点击事件
        if isForbidScrollDelegate == true{
            return
        }
        //1.获取需要的数据 （滚动的进度、sourceIndex（颜色渐变）、targetIndex（要判断左滑还是右滑））
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        //2.判断是左还是右滑动
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX{//手指向左滑动
            //1.计算progress  floor获取的是整数
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.计算currentIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            //4.如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//手指向右滑动
            //1.计算progress  floor获取的是整数
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            )
            //2.计算currentIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
        }
        //3.将progress/sourceIndex/targetIndex传递给progress
        print("progress\(progress) sourceIndex\(sourceIndex) targetIndex \(targetIndex)")
        delegate?.pageContentView(contenView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK: - 对外暴露的方法，Home中PageTitleView的代理方法调用
extension PageContentView{
    func setCurrentIndex(currentIndex: Int){
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        // 2.滚动正确的位置
        let offSetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: false)
    }
}
