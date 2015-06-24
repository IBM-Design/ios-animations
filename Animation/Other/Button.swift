import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class Button: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(MotionStyleKit.motion_Color, forState: .Normal)
    }

}
