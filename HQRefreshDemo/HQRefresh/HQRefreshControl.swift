//
//  HQRefreshControl.swift
//  HQRefreshDemo
//
//  Created by qianhongqiang on 15/8/3.
//  Copyright (c) 2015年 qianhongqiang. All rights reserved.
//

import UIKit

class HQRefreshControl: UIView {

    var percentage : CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HQRefreshControl {
    func addBezierPath(fromPoint:CGPoint, toPoint:CGPoint, fromRadius:CGFloat, toRadius:CGFloat, scale:CGFloat) ->UIBezierPath {
        var path = UIBezierPath();
//        let r = distanceBetweenPoints(fromPoint, pointB: toPoint)
//        let offsetY = fabs(fromRadius-toRadius)
//        if (r <= offsetY) {
//            var centerPos : CGPoint
//            var radiusL :CGFloat
//            if (fromRadius >= toRadius) {
//                centerPos = fromPoint;
//                radiusL = fromRadius;
//            } else {
//                centerPos = toPoint;
//                radiusL = toRadius;
//            }
//            path.addArcWithCenter(centerPos, radius:radiusL, startAngle: 0 as CGFloat, endAngle: 2*M_PI, clockwise: true)
//        } else {
//            CGFloat originX = toPoint.x - fromPoint.x;
//            CGFloat originY = toPoint.y - fromPoint.y;
//            
//            CGFloat fromOriginAngel = (originX >= 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
//            CGFloat fromOffsetAngel = (fromRadius >= toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
//            CGFloat fromStartAngel = fromOriginAngel + fromOffsetAngel;
//            CGFloat fromEndAngel = fromOriginAngel - fromOffsetAngel;
//            
//            CGPoint fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
//            
//            CGFloat toOriginAngel = (originX < 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
//            CGFloat toOffsetAngel = (fromRadius < toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
//            CGFloat toStartAngel = toOriginAngel + toOffsetAngel;
//            CGFloat toEndAngel = toOriginAngel - toOffsetAngel;
//            CGPoint toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
//            
//            CGPoint middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
//            CGFloat middleRadius = (fromRadius+toRadius)/2;
//            
//            CGPoint fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
//            
//            CGPoint toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
//            
//            [path moveToPoint:fromStartPoint];
//            
//            [path addArcWithCenter:fromPoint radius:fromRadius startAngle:fromStartAngel endAngle:fromEndAngel clockwise:YES];
//            
//            if (r > (fromRadius+toRadius)) {
//                [path addQuadCurveToPoint:toStartPoint controlPoint:fromControlPoint];
//            }
//            
//            [path addArcWithCenter:toPoint radius:toRadius startAngle:toStartAngel endAngle:toEndAngel clockwise:YES];
//            
//            if (r > (fromRadius+toRadius)) {
//                [path addQuadCurveToPoint:fromStartPoint controlPoint:toControlPoint];
//            }
//        }
//        
//        [path closePath];
        
        return path;
    }
    
    func distanceBetweenPoints (pointA :CGPoint, pointB :CGPoint) -> CGFloat{
    let deltaX = pointB.x - pointA.x;
    let deltaY = pointB.y - pointA.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
    };
}
