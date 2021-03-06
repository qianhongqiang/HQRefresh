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

let defaultRefreshHit = "下拉刷新"

enum RefreshState {
    case  Pulling               // 松开就可以进行刷新的状态
    case  Normal                // 普通状态
    case  Refreshing            // 正在刷新中的状态
    case  WillRefreshing
}

class HQRefreshView: UIView {
    
    var refreshCallBack : (()->Void)?   //刷新完成的回调
    
    var parentScrollView : UIScrollView?
    var originContentInset : UIEdgeInsets?
    var detailLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailLabel = UILabel(frame: CGRectMake(0, 10, screenWidth, 20))
        detailLabel.text = defaultRefreshHit
        detailLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(self.detailLabel)
        
        self.backgroundColor = UIColor.redColor()
        
        self.currentViewState = RefreshState.Normal
        self.previousViewState = RefreshState.Normal
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        newSuperview!.addObserver(self, forKeyPath: RefreshContentOffSet as String, options: NSKeyValueObservingOptions.New, context: nil)
        parentScrollView = newSuperview as? UIScrollView
        originContentInset = parentScrollView?.contentInset
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        reframe()
    }
    
    func reframe() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previousViewState : RefreshState?
    
    var currentViewState : RefreshState? {
        willSet {
        }
        didSet {
        }
    }
    
}

extension HQRefreshView {
    
    func updateTimeLabel(updateTime:NSDate) -> String {
        var calendar:NSCalendar = NSCalendar.currentCalendar()
        var unitFlags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
        let formatter:NSDateFormatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time:String = formatter.stringFromDate(updateTime)
        return time
        
    }
}
