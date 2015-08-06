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
    
    var refreshControl : HQRefreshControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshControl = HQRefreshControl(frame: CGRectMake((screenWidth - 18)/2, 0, 24, 64))
        self.addSubview(refreshControl!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reframe() {
        self.HQ_originY = -self.HQ_sizeHright - originContentInset!.top
    }
    
    func adjustStateWithContentOffset() {
        var currentOffsetY:CGFloat = self.parentScrollView!.contentOffset.y
        
        self.refreshControl!.percentage = CGFloat(-currentOffsetY/64)
        
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
                
                if previousViewState != RefreshState.Refreshing {
                    return
                }
                
                self.parentScrollView?.userInteractionEnabled = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetTop = self.originContentInset!.top
                    }, completion: { (completed) -> Void in
                })
                break
            case .Pulling:
                break
            case .Refreshing:
                self.parentScrollView?.userInteractionEnabled = false
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetTop = refreshViewHeight + self.originContentInset!.top
                    self.parentScrollView?.HQ_offsetY = -refreshViewHeight
                }, completion: { (completed) -> Void in
                    self.refreshCallBack!()
                })
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
        previousViewState = RefreshState.Normal
    }
}
