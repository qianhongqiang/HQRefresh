//
//  HQRefreshControl.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/3.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

let refreshControlOriginRadius : CGFloat = 12

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
        let absoluteValue = percentage * refreshViewHeight
        
        var startP : CGPoint = CGPointZero,startR : CGFloat = 0,endP : CGPoint = CGPointZero, endR : CGFloat = 0 ,distance :CGFloat = 0
        
        if absoluteValue < 2*refreshControlOriginRadius {
            startP = CGPointMake(refreshControlOriginRadius, refreshViewHeight - refreshControlOriginRadius)
            endP = CGPointMake(refreshControlOriginRadius, refreshViewHeight - refreshControlOriginRadius)
            startR = refreshControlOriginRadius
            endR = refreshControlOriginRadius
        }else if absoluteValue < refreshViewHeight {
            startP = CGPointMake(refreshControlOriginRadius, refreshViewHeight + refreshControlOriginRadius - absoluteValue)
            endP = CGPointMake(refreshControlOriginRadius, refreshViewHeight - refreshControlOriginRadius)
            distance = distanceBetweenPoints(startP, pointB: endP)
            startR = refreshControlOriginRadius - 0.05 * distance
            endR = refreshControlOriginRadius - 0.2 * distance
        }else {
            startP = CGPointMake(refreshControlOriginRadius, refreshControlOriginRadius)
            endP = CGPointMake(refreshControlOriginRadius, refreshViewHeight - refreshControlOriginRadius)
            distance = distanceBetweenPoints(startP, pointB: endP)
            startR = refreshControlOriginRadius - 0.05 * distance
            endR = refreshControlOriginRadius - 0.2 * distance
        }
        
        let bezierPath = self.addBezierPath(startP, toPoint: endP, fromRadius: CGFloat(startR), toRadius: CGFloat(endR), scale: 0.6)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor);
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HQRefreshControl {
    func addBezierPath(fromPoint:CGPoint, toPoint:CGPoint, fromRadius:CGFloat, toRadius:CGFloat, scale:CGFloat) ->UIBezierPath {
        let path = UIBezierPath();
        let r : CGFloat = distanceBetweenPoints(fromPoint, pointB: toPoint)
        let offsetY = fabs(fromRadius-toRadius)
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
            let originX : CGFloat = toPoint.x - fromPoint.x;
            let originY : CGFloat = toPoint.y - fromPoint.y;
            
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
            
            let fromStartAngel = fromOriginAngel + fromOffsetAngel;
            let fromEndAngel = fromOriginAngel - fromOffsetAngel;
            
            let fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
            
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
            
            let toStartAngel = toOriginAngel + toOffsetAngel;
            let toEndAngel = toOriginAngel - toOffsetAngel;
            let toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
            
            let middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
            let middleRadius = (fromRadius+toRadius)/2;
            
            let fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
            
            let toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
            
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
