import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

let easeInOutControlPoints: [CGFloat] = [0.8, 0.0, 0.2, 1.0]

enum LayoutConstraintEasing {

    case Linear
    case Bezier(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat)
    case EaseInOut
    case EaseIn
    case EaseOut
    
    func valueFor(t: CGFloat) -> CGFloat {
        switch (self) {
            
            case let .Linear: return t
            case let .Bezier(x1, y1, x2, y2): return bezier(t, x1:x1, y1:y1, x2:x2, y2:y2)
        
            case let .EaseInOut: return bezier(t, x1:easeInOutControlPoints[0], y1:easeInOutControlPoints[1], x2:easeInOutControlPoints[2], y2:easeInOutControlPoints[3])
            case let .EaseIn: return bezier(t, x1:easeInOutControlPoints[1], y1:easeInOutControlPoints[0], x2:easeInOutControlPoints[2], y2:easeInOutControlPoints[3])
            case let .EaseOut: return bezier(t, x1:easeInOutControlPoints[0], y1:easeInOutControlPoints[1], x2:easeInOutControlPoints[3], y2:easeInOutControlPoints[2])
            
        }
    }
    
    // Simple linear interpolation between two points
    func lerp(a:CGPoint, b:CGPoint, t:CGFloat) -> CGPoint
    {
        return CGPointMake(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
    }
    
    func bezier(t: CGFloat, x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) -> CGFloat {
        
        let cubicBezier = CubicBezier(x1: x1, y1: y1, x2: x2, y2: y2)
        return cubicBezier.valueForX(t)
    }
    
    static var EaseInOutMTF : CAMediaTimingFunction {

        return CAMediaTimingFunction(controlPoints: Float(easeInOutControlPoints[0]), Float(easeInOutControlPoints[1]), Float(easeInOutControlPoints[2]), Float(easeInOutControlPoints[3]))

    }
    
    static var EaseInMTF : CAMediaTimingFunction {
        
        return CAMediaTimingFunction(controlPoints: Float(easeInOutControlPoints[1]), Float(easeInOutControlPoints[0]), Float(easeInOutControlPoints[2]), Float(easeInOutControlPoints[3]))
        
    }
    
    static var EaseOutMTF : CAMediaTimingFunction {
        
        return CAMediaTimingFunction(controlPoints: Float(easeInOutControlPoints[0]), Float(easeInOutControlPoints[1]), Float(easeInOutControlPoints[3]), Float(easeInOutControlPoints[2]))
        
    }
    
}