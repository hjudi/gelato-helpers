//
//  gelato-helpers.swift
//  Hazim Judi
//  MIT license and all that metal \M/
//

import UIKit

//Quick access to the app delegate and system version.

let getAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let version = UIDevice.currentDevice().systemVersion

var isiPhone6 : Bool {
    
    if UIScreen.mainScreen().bounds.size.height == 667.0 {
        return true
    }
    return false
}

var isiPhone6Plus : Bool {
    if UIScreen.mainScreen().bounds.size.height == 736.0 {
        return true
    }
    return false
}

var isiOS9 : Bool {
    
    if version.rangeOfString("9.") != nil { return true }
    return false
}


//Lets you specify padding for the text + placeholder text in a UITextField.

class PaddingTextField : UITextField {
    
    var xPadding = CGFloat(10)
    var yPadding = CGFloat(1)
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRect(x: xPadding, y: yPadding, width: bounds.width-(xPadding*2), height: bounds.height-(self.yPadding*2))
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRect(x: xPadding, y: yPadding, width: bounds.width-(xPadding*2), height: bounds.height-(self.yPadding*2))
    }
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRect(x: xPadding, y: yPadding, width: bounds.width-(xPadding*2), height: bounds.height-(self.yPadding*2))
    }
}


extension NSDate {
    
    //Gives you a lean + modern elapsed time estimate string.
    //Ex. "5m", "13d" ...
    
    func getTimeElapsed() -> String {
        
        let elapsed = abs(self.timeIntervalSinceNow)
        
        if elapsed > 0 && elapsed < 120 {
            
            return "Now"
        }
        else if elapsed > 120 && elapsed < 3600 {
            
            let r = NSString(format: "%.f", elapsed/120)
            return "\(r)m"
        }
        else if elapsed > 3600 && elapsed < 86400 {
            
            let r = NSString(format: "%.f", elapsed/3600)
            return "\(r)h"
        }
        else if elapsed > 86400 && elapsed < 604800 {
            
            let r = NSString(format: "%.f", elapsed/86400)
            return "\(r)d"
        }
        else if elapsed > 604800 && elapsed < 2419200 {
            
            let r = NSString(format: "%.f", elapsed/604800)
            return "\(r)w"
        }
        else if elapsed > 2419200 && elapsed < 29030400 {
            
            let r = NSString(format: "%.f", elapsed/2419200)
            return "\(r)mo"
        }
        else {
            let r = NSString(format: "%.f", elapsed/29030400)
            return "\(r)y"
        }
    }
}


extension UIView {
    
    //Removes all subviews.
    
    func removeAllSubviews() {
        
        for subview in self.subviews {
            
            subview.removeFromSuperview()
        }
    }
    
    
    //Quick access to get/set frame values without "frame.origin" or "frame.size"
    
    var x : CGFloat {
        
        get {
            return self.frame.origin.x
        }
        set(newX) {
            self.frame.origin.x = newX
        }
    }
    var y : CGFloat {
        
        get {
            return self.frame.origin.y
        }
        set(newY) {
            self.frame.origin.y = newY
        }
    }
    var width : CGFloat {
        
        get {
            return self.frame.width
        }
        set(newWidth) {
            self.frame.size.width = newWidth
        }
    }
    var height : CGFloat {
        
        get {
            return self.frame.height
        }
        set(newHeight) {
            self.frame.size.height = newHeight
        }
    }
}

//Self explanatory: turn a 6-character hex value into a UIColor.

func hexToColor(hex: String) -> UIColor? {
    
    if let hexIntValue = UInt(hex, radix: 16) {
        
        return UIColor(
            red: CGFloat((hexIntValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexIntValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexIntValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    return nil
}

//Vice versa.

func colorToHex(color: UIColor) -> String {
    
    let values = color.getRGB()
    
    return String(format: "%02x%02x%02x", Int(values[0]*255), Int(values[1]*255), Int(values[2]*255))
}

//If you use NSAttributedString, this is your lucky day.
//paragraphStyleWithLineHeight() gives you a quick paragraph style with specified settings.

func paragraphStyleWithLineHeight(lineHeight: CGFloat?, alignment: NSTextAlignment?) -> NSParagraphStyle {
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    if lineHeight != nil { paragraphStyle.lineSpacing = lineHeight! }
    if alignment != nil { paragraphStyle.alignment = alignment! }
    
    return paragraphStyle as NSParagraphStyle
}


extension Array {
    
    // No more nil subscript returns!!
    
    subscript (safe index: Int) -> Element? {
        
        return indices ~= index ? self[index] : nil
    }
}

extension String {
    
    //Saved you an extra property
    
    var length: Int { return self.characters.count }
    
    
    //We've all had to deal with value inconsistency + REST APIs before
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    
    //Gives you a simple array of username-valid strings that appear after '@'
    
    //"We @all live in the yellow @submarine" -> ["all", "submarine"]
    
    func toMentionsArray() -> Array<String> {
        
        var arrayOfMentions : Array<String> = []
        
        if self.length > 0 {
            
            var string = self
            var containsMore = true
            
            while containsMore == true && string.length > 0 {
                
                if let r = string.rangeOfString("@") {
                    
                    if arrayOfMentions.count == 0 && r.endIndex == string.endIndex { containsMore = false; break }
                    
                    var finalMentionRange = r
                    finalMentionRange.startIndex++
                    var hitAnObstacle = false
                    
                    while hitAnObstacle == false {
                        
                        if finalMentionRange.endIndex == string.endIndex {
                            
                            hitAnObstacle = true
                            break
                        }
                        if String(string[finalMentionRange.endIndex]).rangeOfCharacterFromSet(NSCharacterSet(charactersInString: " .@:!$%^&*()+=?\"\'[]")) != nil {
                            
                            hitAnObstacle = true
                            break
                        }
                        
                        finalMentionRange.endIndex++
                    }
                    
                    if string.substringWithRange(finalMentionRange) != "" {
                        
                        arrayOfMentions.append(string.substringWithRange(finalMentionRange))
                    }
                    string = string.substringFromIndex(finalMentionRange.endIndex)
                }
                else {
                    
                    containsMore = false
                }
            }
        }
        
        return arrayOfMentions
    }
    
    
    //Shortens URL strings down to their 'roots'
    
    func minifiedLink(link: String) -> String {
        
        var minified = self.lowercaseString.stringByReplacingOccurrencesOfString("http://", withString: "", options: [], range: nil).stringByReplacingOccurrencesOfString("https://", withString: "", options: [], range: nil).stringByReplacingOccurrencesOfString("www.", withString: "", options: [], range: nil)
        
        if let r = minified.rangeOfString("/") {
            
            let range = r.startIndex..<minified.endIndex
            minified = minified.stringByReplacingCharactersInRange(range, withString: link)
        }
        else {
            
            minified += link
        }
        
        return minified
    }
}

extension UIImage {
    
    //Returns a version of the image with the specified alpha. No more selected state assets!
    
    func dimWithAlpha(alpha: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRect(origin: CGPointZero, size: self.size), blendMode: .Normal, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //Fills the opaque parts of an image with the specified color.
    
    func fillWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let c = UIGraphicsGetCurrentContext()
        self.drawInRect(CGRect(origin: CGPointZero, size: self.size), blendMode: .Normal, alpha: 1)
        CGContextSetBlendMode(c, CGBlendMode.SourceIn)
        CGContextSetFillColorWithColor(c, color.CGColor)
        CGContextFillRect(c, CGRect(origin: CGPointZero, size: self.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

extension UIColor {
    
    //Gives a single-pt image representation of the color, for use as a lazy BG sprite.
    
    func toImage() -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, self.CGColor);
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    //Makes the image darker/brighter by the specified percentage.
    //<White>.darkerByPercentage(percentage: 1.0) -> <Black>
    
    func darkerByPercentage(percentage: CGFloat) -> UIColor {
        
        var red = CGFloat(); var green = CGFloat(); var blue = CGFloat(); var a = CGFloat()
        self.getRed(&red, green: &green, blue: &blue, alpha: &a)
        
        return UIColor(red: red-percentage, green: green-percentage, blue: blue-percentage, alpha: a)
    }
    
    func lighterByPercentage(percentage: CGFloat) -> UIColor {
        
        var red = CGFloat(); var green = CGFloat(); var blue = CGFloat(); var a = CGFloat()
        self.getRed(&red, green: &green, blue: &blue, alpha: &a)
        
        return UIColor(red: red+percentage, green: green+percentage, blue: blue+percentage, alpha: a)
    }
    
    
    //Gives a 4-value collection of a color's RGBA values. <Red>.getRGBA()[0] -> 1.0
    
    func getRGBA() -> [CGFloat] {
        
        var red = CGFloat(); var green = CGFloat(); var blue = CGFloat(); var alpha = CGFloat()
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red,green,blue,alpha]
    }
}
