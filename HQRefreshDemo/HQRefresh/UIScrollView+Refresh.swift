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
        let refreshView : HQRefreshHaederView = HQRefreshHaederView.header()
        refreshView.refreshCallBack = callBack
        self.addSubview(refreshView)
    }
    
    func addRefreshFooterWithCallBack(callBack:(()->Void)!){
        let refreshView : HQRefreshFooterView = HQRefreshFooterView.footer()
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
            let offsetY = self.contentOffset.y
            return offsetY;
        }
    }
    
    var HQ_offsetX : CGFloat {
        set{
            var cmp : CGPoint = self.contentOffset
            cmp.x = newValue
        }
        
        get{
            let offsetX = self.contentOffset.x
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
            let insetTop = self.contentInset.top
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
            let insetBottom = self.contentInset.bottom
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
            let insetLeft = self.contentInset.left
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
            let insetRight = self.contentInset.right
            return insetRight;
        }
    }
}

