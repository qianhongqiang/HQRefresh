//
//  HQRefreshView.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/7/30.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit
//constant
let screenWidth : CGFloat = UIScreen.mainScreen().bounds.width
let refreshHeaderViewHeight : CGFloat = 64

let RefreshContentOffSet = "contentOffset"

enum RefreshState {
    case  Pulling               // 松开就可以进行刷新的状态
    case  Normal                // 普通状态
    case  Refreshing            // 正在刷新中的状态
    case  WillRefreshing
}

class HQRefreshView: UIView {
    
    var refreshCallBack : (()->Void)?
    
    var parentScrollView : UIScrollView?
    var originContentInset : UIEdgeInsets?
    var detailLabel : UILabel!
    
    class func header()->HQRefreshView {
        var refreshView = HQRefreshView(frame: CGRectMake(0, -refreshHeaderViewHeight, screenWidth, refreshHeaderViewHeight))
        refreshView.backgroundColor = UIColor.yellowColor()
        return refreshView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailLabel = UILabel(frame: CGRectMake(0, 10, screenWidth, 20))
        detailLabel.text = "refresh"
        detailLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(self.detailLabel)
        
        self.currentViewState = RefreshState.Normal
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        newSuperview!.addObserver(self, forKeyPath: RefreshContentOffSet as String, options: NSKeyValueObservingOptions.New, context: nil)
        parentScrollView = newSuperview as? UIScrollView
        originContentInset = parentScrollView?.contentInset
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if RefreshContentOffSet.isEqual(keyPath) {
            adjustStateWithContentOffset()
        }
    }
    
    func adjustStateWithContentOffset() {
        var currentOffsetY:CGFloat = self.parentScrollView!.contentOffset.y
        var happenOffsetY:CGFloat = -self.originContentInset!.top
        if (currentOffsetY >= happenOffsetY) {
            return
        }
        if self.parentScrollView!.dragging {
            if currentOffsetY < -refreshHeaderViewHeight {
                currentViewState = RefreshState.WillRefreshing
            }else {
                currentViewState = RefreshState.Normal
            }
        }else {
            if currentViewState != RefreshState.Refreshing && currentOffsetY < -refreshHeaderViewHeight {
                currentViewState = RefreshState.Refreshing
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previousViewState : RefreshState?
    
    var currentViewState : RefreshState? {
        willSet {
            if currentViewState == newValue {
                return
            }
            previousViewState = currentViewState
            self.currentViewState = newValue
        }
        didSet {
            switch currentViewState! {
            case .Normal:
                self.parentScrollView?.userInteractionEnabled = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetTop = 0
                }, completion: { (completed) -> Void in
                    self.parentScrollView?.HQ_offsetY = -0
                })
                break
            case .Pulling:
                break
            case .Refreshing:
                self.parentScrollView?.userInteractionEnabled = false
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetTop = refreshHeaderViewHeight
                    self.parentScrollView?.HQ_offsetY = -refreshHeaderViewHeight
                })
                self.refreshCallBack!()
                break
            case .WillRefreshing:
                break
            default:
                break
            }
        }
    }
    
}

extension HQRefreshView {
    func endRefreshing() {
        currentViewState = RefreshState.Normal
    }
}
