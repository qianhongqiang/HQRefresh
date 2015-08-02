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
let refreshViewHeight : CGFloat = 64

let RefreshContentOffSet = "contentOffset"

enum RefreshState {
    case  Pulling               // 松开就可以进行刷新的状态
    case  Normal                // 普通状态
    case  Refreshing            // 正在刷新中的状态
    case  WillRefreshing
}

enum RefreshViewType {
    case Header
    case Footer
}

class HQRefreshView: UIView {
    
    var refreshCallBack : (()->Void)?   //刷新完成的回调
    
    var parentScrollView : UIScrollView?
    var originContentInset : UIEdgeInsets?
    var detailLabel : UILabel!
    
    var viewType : RefreshViewType?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.viewType == RefreshViewType.Footer {
            let height = superview?.frame.height
            self.frame = CGRectMake(0, height!, screenWidth, refreshViewHeight)
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

extension HQRefreshView {
    
    func updateTimeLabel(updateTime:NSDate) -> String {
        var calendar:NSCalendar = NSCalendar.currentCalendar()
        var unitFlags:NSCalendarUnit = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay |  NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
        var formatter:NSDateFormatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        var time:String = formatter.stringFromDate(updateTime)
        return time
        
    }
}
