//
//  Layout.swift
//  Conversation MF
//
//  Created by Rafael Moris on 05/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit

class Layout {
    static let shared = Layout()
    
    fileprivate init() {}
    
    var refreshLayout = false
    
    var globalTintColor:String? = "#212121"
    
    var btnSpeechTintColor:String? = "#ffffff"
    var btnSpeechBackgroundColor:String? = "#256ed4"
    
    var btnGalleryTintColor:String? = "#ffffff"
    var btnGalleryBackgroundColor:String? = "#b3c4e0"
    
    var btnCameraTintColor:String? = "#ffffff"
    var btnCameraBackgroundColor:String? = "#2edef8"
    
    var btnSettingsTintColor:String? = "#757575"
    var btnSettingsBackgroundColor:String = "#ffffff"
    
    var btnTextMessageTintColor:String? = "#ffffff"
    var btnTextMessageBackgroundColor:String? = "#ee6b72"
    
    var btnSpeechMessageTintColor:String? = "#ffffff"
    var btnSpeechMessageBackgroundColor:String? = "#256ed4"
    
    var txtMessageTextColor:String? = "#000000"
    var txtMessageBackgroundColor:String? = "#f7babe"
    
    
    var userMessageTextColor:String? = "#ffffff"
    var userMessageBackgroundColor:String? = "#ef7c00"
    
    var watsonMessageTextColor:String? = "#ffffff"
    var watsonMessageBackgroundColor:String? = "#46bedc"
    
    
    func colorForString(_ string:String?)->UIColor {
        return string != nil ? UIColor(hexString: string!) : UIColor.clear
    }
    
//    func colorForString(_ string:String?, withAlpha alpha:CGFloat)->UIColor {
//        
//        if self.chooseRandomColors {
//            return self.randomColorWithAlpha(alpha)
//        }
//        
//        var color = string != nil ? UIColor(hexString: string!) : UIColor.clear
//        
//        if let values = self.colorValues(color: color) {
//            color = UIColor(red: values.red, green: values.green, blue: values.blue, alpha: alpha)
//        }
//        
//        return color
//    }
    
    func colorValues(color:UIColor)->(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red:red, green:green, blue:blue, alpha:alpha)
        }else {
            return nil
        }
    }
    
//    func randomColorWithAlpha(_ alpha:CGFloat)->UIColor {
//        let red = CGFloat(Math.random(min: 0, max: 255)) / 255.0
//        let green = CGFloat(Math.random(min: 0, max: 255)) / 255.0
//        let blue = CGFloat(Math.random(min: 0, max: 255)) / 255.0
//
//        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
//    }
}
