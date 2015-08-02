//
//  HQRefreshFooterView.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/2.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

class HQRefreshFooterView: HQRefreshView {
    
    var lastRefreshCount:Int = 0

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if RefreshContentOffSet.isEqual(keyPath) {
            adjustStateWithContentOffset()
        }
    }
    
    func adjustStateWithContentOffset() {
        var currentOffsetY:CGFloat = self.parentScrollView!.contentOffset.y
        var happenOffsetY:CGFloat = -self.originContentInset!.bottom
        if (currentOffsetY <= happenOffsetY) {
            return
        }
        if self.parentScrollView!.dragging {
            if currentOffsetY > refreshViewHeight {
                currentViewState = RefreshState.WillRefreshing
            }else {
                currentViewState = RefreshState.Normal
            }
        }else {
            if currentViewState != RefreshState.Refreshing && currentOffsetY > refreshViewHeight {
                currentViewState = RefreshState.Refreshing
            }
        }
    }
    
    override func reframe() {
        let superviewHeight = superview?.frame.height
        self.frame = CGRectMake(0, superviewHeight!, screenWidth, refreshViewHeight)
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
                if self.previousViewState == currentViewState {
                    return
                }
                
                self.parentScrollView?.userInteractionEnabled = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetBottom = 0
                    }, completion: { (completed) -> Void in
                        self.parentScrollView?.HQ_offsetY = -0
                })
                
                var deltaH:CGFloat = self.heightForContentBreakView()
                var currentCount:Int = self.totalDataCountInScrollView()
                if (RefreshState.Refreshing == previousViewState && deltaH > 0  && currentCount != self.lastRefreshCount) {
                    var offset:CGPoint = self.parentScrollView!.contentOffset;
                    offset.y = self.parentScrollView!.contentOffset.y
                    self.parentScrollView?.contentOffset = offset;
                }
                
                break
            case .Pulling:
                break
            case .Refreshing:
                self.parentScrollView?.userInteractionEnabled = false
                
                self.lastRefreshCount = self.totalDataCountInScrollView();
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    var bottom:CGFloat = self.frame.size.height + self.originContentInset!.bottom
                    println("\(bottom)")
                    var deltaH:CGFloat = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    var inset:UIEdgeInsets = self.parentScrollView!.contentInset;
                    inset.bottom = bottom;
                    println("\(bottom)")
                    self.parentScrollView?.contentInset = inset;
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
    
    func heightForContentBreakView()->CGFloat
    {
        var h:CGFloat  = self.parentScrollView!.frame.size.height - self.originContentInset!.bottom - self.originContentInset!.top;
        return self.parentScrollView!.contentSize.height - h;
    }
    
    func  totalDataCountInScrollView()->Int
    {
        var totalCount:Int = 0
        if self.parentScrollView is UITableView {
            var tableView:UITableView = self.parentScrollView as! UITableView
            
            for (var i:Int = 0 ; i <  tableView.numberOfSections() ; i++){
                totalCount = totalCount + tableView.numberOfRowsInSection(i)
                
            }
        } else if self.parentScrollView is UICollectionView{
            var collectionView:UICollectionView = self.parentScrollView as! UICollectionView
            for (var i:Int = 0 ; i <  collectionView.numberOfSections() ; i++){
                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
                
            }
        }
        return totalCount
    }

}

extension HQRefreshFooterView {
    class func footer()->HQRefreshFooterView {
        var refreshView = HQRefreshFooterView(frame: CGRectMake(0, 0, screenWidth, refreshViewHeight))
        return refreshView
    }
    
    func endFooterRefreshing() {
        detailLabel.text = updateTimeLabel(NSDate())
        currentViewState = RefreshState.Normal
    }
}
