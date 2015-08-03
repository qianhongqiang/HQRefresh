//
//  UIView+Custom.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/3.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var HQ_originX :CGFloat {
        set {
            var cmp : CGPoint = self.frame.origin
            cmp.x = newValue
            self.frame.origin = cmp;
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var HQ_originY :CGFloat {
        set {
            var cmp : CGPoint = self.frame.origin
            cmp.y = newValue
            self.frame.origin = cmp;
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var HQ_sizeWidth :CGFloat {
        set {
            var cmp : CGSize = self.frame.size
            cmp.width = newValue
            self.frame.size = cmp;
        }
        get {
            return self.frame.size.width
        }
    }
    
    var HQ_sizeHright :CGFloat {
        set {
            var cmp : CGSize = self.frame.size
            cmp.height = newValue
            self.frame.size = cmp;
        }
        get {
            return self.frame.size.height
        }
    }
}
