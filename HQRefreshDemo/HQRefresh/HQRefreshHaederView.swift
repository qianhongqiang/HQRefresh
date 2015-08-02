//
//  HQRefreshHaederView.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/2.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

class HQRefreshHaederView: HQRefreshView {

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
            if currentOffsetY < -refreshViewHeight {
                currentViewState = RefreshState.WillRefreshing
            }else {
                currentViewState = RefreshState.Normal
            }
        }else {
            if currentViewState != RefreshState.Refreshing && currentOffsetY < -refreshViewHeight {
                currentViewState = RefreshState.Refreshing
            }
        }
    }
    
    override var currentViewState : RefreshState? {
        willSet {
            if currentViewState == newValue {
                return
            }
            previousViewState = currentViewState
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
                    self.parentScrollView?.HQ_edgeInsetTop = refreshViewHeight
                    self.parentScrollView?.HQ_offsetY = -refreshViewHeight
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

extension HQRefreshHaederView {
    class func header()->HQRefreshHaederView {
        var refreshView = HQRefreshHaederView(frame: CGRectMake(0, -refreshViewHeight, screenWidth, refreshViewHeight))
        return refreshView
    }
    
    func endHeaderRefreshing() {
        detailLabel.text = updateTimeLabel(NSDate())
        currentViewState = RefreshState.Normal
    }
}