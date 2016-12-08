//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by 郑亚伟 on 16/12/8.
//  Copyright © 2016年 郑亚伟. All rights reserved.
//

import UIKit


//MARK:-定义协议
/*************************************/
protocol PageTitleViewDelegate : class {
    //selectedIndex是外部参数  index是内部参数
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

// MARK:- 定义常量
private let kScrollLineH: CGFloat = 2
/*******************/
//定义元组
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    //用属性保存标题
     var titles: [String]
    //当前选中label的下标
     var currentIndex: Int = 0
    
    //weak只能修饰可选的
    /*********************************/
    weak var delegate: PageTitleViewDelegate?
    
    //MARK:-懒加载属性
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        //MARK:-查scrollsToTop
        /*??????????????????????????????????????*/
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        return scrollView
        scrollView.bounces = false
    }()
    
    lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    lazy var titlesLabel: [UILabel] = [UILabel]()
    
    //MARK:-自定义构造函数
    init(frame: CGRect, titles: [String]) {
        //用属性保存外部传入的标题
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    //自定义构造函数必须要实现该方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView{
    func setupUI(){
        //1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        //2.添加titles对应的label
        setupTitleLabels()
        //3.设置底线和滑块
        setupBottomMenuAndScrollLine()
    }
    private func setupTitleLabels(){
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH * 2
        let labelY: CGFloat = 0
        for (index,title) in titles.enumerated(){
            //1。创建label
            let label = UILabel()
            //2.设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 17)
            label.textAlignment = .center
             label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b:kNormalColor.2, alpha: 1.0)
            //3.设置label的frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.添加label
            scrollView.addSubview(label)
            titlesLabel.append(label)
            
            //5.label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
            label.addGestureRecognizer(tapGes)
        }
    }
    private func setupBottomMenuAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 8.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        //2.添加scrollLine
        //2.1获取第一个label
        guard let firstLabel = titlesLabel.first else { return}
        scrollView.addSubview(scrollLine)
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2, alpha:1.0)
        //2.2设置scrollLine的属性
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.size.width, height: kScrollLineH)
    }
}

// MARK: - 监听label的点击事件
extension PageTitleView{
    @objc func titleLabelClick(tapGes: UITapGestureRecognizer){
        //1.获取当前点击label
        guard let currentLabel = tapGes.view as? UILabel else{
            return
        }
        //2.获取之前label
        let oldLabel = titlesLabel[currentIndex]
        //3.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //4.保存最新label 的下标
        currentIndex = currentLabel.tag
        //5.滚动条位置变化
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.25) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        //6.通知代理做事情
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}


// MARK: - 对外暴露的方法。在HomeVc中调用，pageContentView的scrollView滑动的方法，然后pageContentView中的代理方法，调用这个方法
extension PageTitleView{
    func setTitltWithProgress(progress:CGFloat, sourceIndex:Int, targetIndex:Int){
        //1.取出sourceLabel和targetLabel
        let sourceLabel = titlesLabel[sourceIndex]
        let targetLabel = titlesLabel[targetIndex]
        //2.处理滑动的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //3.颜色的渐变
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}
