//
//  ViewController.swift
//  ScollController
//
//  Created by 薛银亮 on 16/6/30.
//  Copyright © 2016年 薛银亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    
    /**  contentView数量  */
    let contentCount = 2
    /**  contentView  */
    let contentView = UIScrollView()
    /**  titleView  */
    let titleView = UIView()
    /**  titleView下边的红线  */
    let indicateLine = UIView()
    /**  选中的的button  */
    var selectedBtn:UIButton?
    /**  当前页面  */
    var currentPage:Int{
        return Int(contentView.contentOffset.x / view.frame.size.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置naviBar
        setUpNaviBar()
        // 添加子控制器
        addChildViewControllers()
        // 添加scrollView容器
        setUpContentView()
        // 添加titleView
        setUpTitleView()
    }
    
    /**
     设置naviBar
     */
    func setUpNaviBar() { }
    
    /**
     添加所有子控制器
     */
    func addChildViewControllers() {
        
        addChildViewController(OneViewController())
        addChildViewController(TwoViewController())
    }
    
    /**
     设置scrollView的容器
     */
    func setUpContentView() {
        
        automaticallyAdjustsScrollViewInsets = false
        contentView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        contentView.pagingEnabled = true
        contentView.contentSize = CGSize(width: view.frame.size.width * CGFloat( contentCount), height: view.frame.size.height)
//        contentView.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.delegate = self
        view.addSubview(contentView)
        
        for i in 0..<childViewControllers.count {
            let viewController = childViewControllers[i]
            viewController.view.frame = CGRectMake(CGFloat(i) * contentView.frame.size.width, 0, contentView.frame.size.width, contentView.frame.size.height)
            contentView.addSubview(viewController.view)
        }
        
    }

    
    /**
     添加titleView
     */
    func setUpTitleView (){
        
        titleView.frame = CGRect(x: (view.frame.size.width - 150)/2, y: 20, width: 150, height: 35)
        titleView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.addSubview(titleView)
        
        indicateLine.frame = CGRect(x: 0, y: 33, width: 20, height: 2)
        indicateLine.backgroundColor = UIColor.redColor()
        
        let width = view.frame.width * 0.2
        let height = titleView.frame.height
        
        let array = ["One","Two"]
        
        for i in 0 ..< contentCount {
            
            let button = UIButton(type: .Custom)
            button.tag = i
            button.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            button.setTitle(array[i], forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.setTitleColor(UIColor.redColor(), forState: .Disabled)
            
            button.addTarget(self, action:#selector(ViewController.didTouchTitleBtn(_:)) , forControlEvents: .TouchUpInside)
            titleView.addSubview(button)
            
            if i == 0 {
                didTouchTitleBtn(button)
                button.titleLabel?.sizeToFit()
                self.indicateLine.frame.size.width = button.titleLabel!.frame.width
                self.indicateLine.center.x = button.center.x
                
                scrollViewDidEndScrollingAnimation(contentView)
            }
            titleView.addSubview(indicateLine)
        }
        
    }
    
    // 点击titleBtn
    func didTouchTitleBtn(sender: UIButton) {
        
        self.selectedBtn?.enabled = true
        self.selectedBtn = sender
        
        sender.enabled = false
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.indicateLine.frame.size.width = sender.titleLabel!.frame.width
            self.indicateLine.center.x = sender.center.x
        }
        contentView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * view.frame.size.width, y: 0), animated: true)
    }

    
    /**
     停止滚动动画的时候执行
     */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        let willShowChildVc = childViewControllers[Int(index)]
        if willShowChildVc.isViewLoaded() == true {
            // 如果这个子控制器的view已经添加过了，就直接返回
            return
        }
         // 添加子控制器的view
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        let  offset = CGPointMake(CGFloat(page) * contentView.frame.size.width, 0)
        self.contentView.setContentOffset(offset, animated: true)
        
    }
    
    /**
     停止惯性的时候执行
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        scrollViewDidEndScrollingAnimation(scrollView)
        didTouchTitleBtn(titleView.subviews[currentPage] as! UIButton)   
    }
    
    

    
    
}

