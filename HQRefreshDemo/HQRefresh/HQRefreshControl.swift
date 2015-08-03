//
//  HQRefreshControl.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/3.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

class HQRefreshControl: UIView {

    var percentage : CGFloat!{
        willSet {
            
        }
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        percentage = 0;
    }
    
    override func drawRect(rect: CGRect) {
        var absoluteValue = percentage * 64
        
        var startP : CGPoint = CGPointZero,startR : CGFloat = 0,endP : CGPoint = CGPointZero, endR : CGFloat = 0 ,distance :CGFloat = 0
        
        if absoluteValue < 18 {
            startP = CGPointMake(9, 55)
            endP = CGPointMake(9, 55)
            startR = 9
            endR = 9
        }else if absoluteValue < 64 {
            startP = CGPointMake(9, 73-absoluteValue)
            endP = CGPointMake(9, 55)
            distance = distanceBetweenPoints(startP, pointB: endP)
            startR = 9 - 0.05 * distance
            endR = 9 - 0.12 * distance
        }else {
            startP = CGPointMake(9, 9)
            endP = CGPointMake(9, 55)
            distance = distanceBetweenPoints(startP, pointB: endP)
            startR = 9 - 0.05 * distance
            endR = 9 - 0.12 * distance
        }
        
        var bezierPath = self.addBezierPath(startP, toPoint: endP, fromRadius: CGFloat(startR), toRadius: CGFloat(endR), scale: 0.7)
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor);
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HQRefreshControl {
    func addBezierPath(fromPoint:CGPoint, toPoint:CGPoint, fromRadius:CGFloat, toRadius:CGFloat, scale:CGFloat) ->UIBezierPath {
        var path = UIBezierPath();
        var r : CGFloat = distanceBetweenPoints(fromPoint, pointB: toPoint)
        var offsetY = fabs(fromRadius-toRadius)
        if (r <= offsetY) {
            var centerPos : CGPoint
            var radius : CGFloat
            if (fromRadius >= toRadius) {
                centerPos = fromPoint;
                radius = fromRadius;
            } else {
                centerPos = toPoint;
                radius = toRadius;
            }
            path.addArcWithCenter(centerPos, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        }else {
            var originX : CGFloat = toPoint.x - fromPoint.x;
            var originY : CGFloat = toPoint.y - fromPoint.y;
            
            var fromOriginAngel : CGFloat
            if originX >= 0 {
                fromOriginAngel = atan(originY/originX)
            }else {
                fromOriginAngel = atan(originY/originX)+CGFloat(M_PI)
            }
            
            var fromOffsetAngel : CGFloat
            if fromRadius >= toRadius {
                fromOffsetAngel = acos(offsetY/r)
            }else {
                fromOffsetAngel = CGFloat(M_PI)-acos(offsetY/r)
            }
            
            var fromStartAngel = fromOriginAngel + fromOffsetAngel;
            var fromEndAngel = fromOriginAngel - fromOffsetAngel;
            
            var fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
            
            var toOriginAngel : CGFloat
            if originX < 0 {
                toOriginAngel = atan(originY/originX)
            }else {
                toOriginAngel = atan(originY/originX)+CGFloat(M_PI)
            }
            var toOffsetAngel : CGFloat
            if fromRadius < toRadius {
                toOffsetAngel = acos(offsetY/r)
            }else {
                toOffsetAngel = CGFloat(M_PI)-acos(offsetY/r)
            }
            
            var toStartAngel = toOriginAngel + toOffsetAngel;
            var toEndAngel = toOriginAngel - toOffsetAngel;
            var toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
            
            var middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
            var middleRadius = (fromRadius+toRadius)/2;
            
            var fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
            
            var toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
            
            path.moveToPoint(fromStartPoint)
            path.addArcWithCenter(fromPoint, radius: fromRadius, startAngle: fromStartAngel, endAngle: fromEndAngel, clockwise: true)
            
            if (r > (fromRadius+toRadius)) {
                path.addQuadCurveToPoint(toStartPoint, controlPoint: fromControlPoint)
            }
            
            path.addArcWithCenter(toPoint, radius: toRadius, startAngle: toStartAngel, endAngle: toEndAngel, clockwise: true)
            
            if (r > (fromRadius+toRadius)) {
                path.addQuadCurveToPoint(fromStartPoint, controlPoint: toControlPoint)
            }
        }
        
        path.closePath()
        return path;
    }
    
    func distanceBetweenPoints (pointA :CGPoint, pointB :CGPoint) -> CGFloat{
    let deltaX = pointB.x - pointA.x;
    let deltaY = pointB.y - pointA.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
    };
}
