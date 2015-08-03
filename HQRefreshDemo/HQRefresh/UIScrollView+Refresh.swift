//
//  UIScrollView+Refresh.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/7/30.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func addRefreshHeaderWithCallBack(callBack:(()->Void)!){
        var refreshView : HQRefreshHaederView = HQRefreshHaederView.header()
        refreshView.refreshCallBack = callBack
        self.addSubview(refreshView)
    }
    
    func addRefreshFooterWithCallBack(callBack:(()->Void)!){
        var refreshView : HQRefreshFooterView = HQRefreshFooterView.footer()
        refreshView.refreshCallBack = callBack
        self.addSubview(refreshView)
    }
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is HQRefreshHaederView {
                let cmp : HQRefreshHaederView = object as! HQRefreshHaederView
                cmp.endHeaderRefreshing()
            }
        }
        
    }
    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is HQRefreshFooterView {
                let cmp : HQRefreshFooterView = object as! HQRefreshFooterView
                cmp.endFooterRefreshing()
            }
        }
        
    }
}

extension UIScrollView {
    var HQ_offsetY : CGFloat {
        set{
            var cmp : CGPoint = self.contentOffset
            cmp.y = newValue
        }
        
        get{
            var offsetY = self.contentOffset.y
            return offsetY;
        }
    }
    
    var HQ_offsetX : CGFloat {
        set{
            var cmp : CGPoint = self.contentOffset
            cmp.x = newValue
        }
        
        get{
            var offsetX = self.contentOffset.x
            return offsetX;
        }
    }
}

extension UIScrollView {
    var HQ_edgeInsetTop : CGFloat {
        set{
            var cmp : UIEdgeInsets = self.contentInset
            cmp.top = newValue
            self.contentInset = cmp
        }
        
        get{
            var insetTop = self.contentInset.top
            return insetTop;
        }
    }
    
    var HQ_edgeInsetBottom : CGFloat {
        set{
            var cmp : UIEdgeInsets = self.contentInset
            cmp.bottom = newValue
            self.contentInset = cmp
        }
        
        get{
            var insetBottom = self.contentInset.bottom
            return insetBottom;
        }
    }
    
    var HQ_edgeInsetLeft : CGFloat {
        set{
            var cmp : UIEdgeInsets = self.contentInset
            cmp.left = newValue
            self.contentInset = cmp
        }
        
        get{
            var insetLeft = self.contentInset.left
            return insetLeft;
        }
    }
    
    var HQ_edgeInsetRight : CGFloat {
        set{
            var cmp : UIEdgeInsets = self.contentInset
            cmp.right = newValue
            self.contentInset = cmp
        }
        
        get{
            var insetRight = self.contentInset.right
            return insetRight;
        }
    }
}

