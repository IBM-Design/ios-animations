import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class Label: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = MotionStyleKit.motion_Color
    }

}
