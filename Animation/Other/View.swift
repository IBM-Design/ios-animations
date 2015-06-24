import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

@IBDesignable class View: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = MotionStyleKit.motion_Color
    }
    
    override func drawRect(rect: CGRect) {
        let rectanglePath = UIBezierPath(rect: rect)
        backgroundColor?.setFill()
        rectanglePath.fill()
    }

}
