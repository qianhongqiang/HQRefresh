//
//  ViewController.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/7/29.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dataSource : NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataSource = NSMutableArray()
        for index in 1...5 {
            self.dataSource?.addObject("\(index)")
        }
        
        self.view.backgroundColor = UIColor.yellowColor()
        
        let testTable : UITableView = UITableView(frame: self.view.bounds)
        testTable.backgroundColor = UIColor.brownColor()
        testTable.delegate = self;
        testTable.dataSource = self;
        testTable.tableFooterView = UIView()
        testTable.contentInset = UIEdgeInsetsMake(30, 0, 30, 0)
        self.view.addSubview(testTable)
        
        print("testTable\(testTable.frame.height)")
        
        
        testTable.addRefreshHeaderWithCallBack { () -> Void in
            let delayInSeconds = 1.0
            for index in 1...4 {
                self.dataSource?.addObject("\(index)")
            }
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
            dispatch_after(popTime, dispatch_get_main_queue()) {
                testTable .reloadData()
                testTable.headerEndRefreshing()
            }

        }
        
        testTable.addRefreshFooterWithCallBack { () -> Void in
            let delayInSeconds = 1.0
            for index in 1...4 {
                self.dataSource?.addObject("\(index)")
            }
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
            dispatch_after(popTime, dispatch_get_main_queue()) {
                testTable .reloadData()
                testTable.footerEndRefreshing()
            }

        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("testTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "testTableViewCell")
        }
        
        cell!.textLabel!.text = self.dataSource?.objectAtIndex(indexPath.row) as? String
        cell?.backgroundColor = UIColor.yellowColor()
        return cell!
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

