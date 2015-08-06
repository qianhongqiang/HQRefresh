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
    var lastBottomDelta : CGFloat = 0
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if RefreshContentOffSet.isEqual(keyPath) {
            adjustStateWithContentOffset()
            let cmp : UITableView = superview as! UITableView
            originContentInset = cmp.contentInset
            if self.parentScrollView!.contentSize.height > self.parentScrollView!.frame.height {
                self.frame.origin.y = self.parentScrollView!.contentSize.height
            }
        }
    }
    
    func adjustStateWithContentOffset() {
        var currentOffsetY:CGFloat = self.parentScrollView!.contentOffset.y
        var happenOffsetY:CGFloat = self.happenOffsetY()
        if (currentOffsetY <= happenOffsetY) {
            return
        }
        if self.parentScrollView!.dragging {
            if currentOffsetY > refreshViewHeight - originContentInset!.bottom{
                currentViewState = RefreshState.WillRefreshing
            }else {
                currentViewState = RefreshState.Normal
            }
        }else {
            if currentViewState != RefreshState.Refreshing && currentOffsetY > refreshViewHeight - originContentInset!.bottom {
                currentViewState = RefreshState.Refreshing
            }
        }
    }
    
    override func reframe() {
        let superviewHeight = superview?.frame.height
        let totalHeight = parentScrollView!.contentSize.height + originContentInset!.top + originContentInset!.bottom
        
        if superviewHeight > totalHeight {
            self.HQ_originY = superviewHeight! - originContentInset!.bottom
        }else {
            self.HQ_originY = totalHeight
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
                if previousViewState == RefreshState.Refreshing {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.parentScrollView?.HQ_edgeInsetBottom -= self.lastBottomDelta
                    })
                }
                
                var deltaH:CGFloat = self.heightForContentBreakView()
                var currentCount:Int = self.totalDataCountInScrollView()
                if (RefreshState.Refreshing == previousViewState && deltaH > 0  && currentCount != self.lastRefreshCount) {
                }
                
                break
            case .Pulling:
                break
            case .Refreshing:
                self.parentScrollView?.userInteractionEnabled = false
                
                self.lastRefreshCount = self.totalDataCountInScrollView();
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    var bottom:CGFloat = self.frame.size.height + self.originContentInset!.bottom
                    var deltaH:CGFloat = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    
                    self.lastBottomDelta = bottom - self.parentScrollView!.HQ_edgeInsetBottom;
                    
                    var inset:UIEdgeInsets = self.parentScrollView!.contentInset;
                    inset.bottom = bottom;

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
    
    func happenOffsetY()->CGFloat {
        var deltaH:CGFloat = self.heightForContentBreakView()
        if deltaH > 0 {
            return   deltaH - self.originContentInset!.top;
        } else {
            return  -self.originContentInset!.top;
        }
    }
    
    func heightForContentBreakView()->CGFloat {
        var visibleHeight:CGFloat  = self.parentScrollView!.frame.size.height - self.originContentInset!.bottom - self.originContentInset!.top;
        return self.parentScrollView!.contentSize.height - visibleHeight;
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
        previousViewState = RefreshState.Normal
    }
}
