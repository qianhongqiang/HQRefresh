//
//  HQDelayTool.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/11/18.
//  Copyright © 2015年 qianhongqiang. All rights reserved.
//

import Foundation

typealias Task = (cancel:Bool) -> ()

func delay(time:NSTimeInterval,task:() -> ()) -> Task? {
    func dispatch_later(block:() -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    }
    
    var closure: dispatch_block_t? = task
    var result: Task?
    
    let delayClousre: Task = { cancel in
        if let internalClosure = closure {
            if cancel == false {
                dispatch_async_main_queen(internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayClousre
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }
    return result
}

func cancel(task:Task?) {
    task?(cancel: true)
}

func dispatch_async_main_queen(block:() -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}