import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
This class provides helper methods & objects regarding colors.
*/

public class MotionStyleKit : NSObject {

    // MARK: - Cache
    private struct Cache {
        static var motion_Color: UIColor = UIColor(red: 0.000, green: 0.706, blue: 0.627, alpha: 1.000)
        static var motion_DarkColor: UIColor = MotionStyleKit.motion_Color.colorWithBrightness(0.525)
    }

    // MARK: - Colors
    public class var motion_Color: UIColor { return Cache.motion_Color }
    public class var motion_DarkColor: UIColor { return Cache.motion_DarkColor }
    
}

extension UIColor {
    func colorWithBrightness(newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 1.0, saturation: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
}