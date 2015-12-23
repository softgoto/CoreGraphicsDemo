//
//  XHSlider.swift
//  CoreGraphicsDemo
//
//  Created by xuhui on 15/12/23.
//  Copyright © 2015年 softgoto. All rights reserved.
//

import UIKit

struct Config{
    
    static let TB_SLIDER_SIZE:CGFloat = UIScreen.mainScreen().bounds.size.width
    static let TB_SAFEAREA_PADDING:CGFloat = 60.0
    static let TB_LINE_WIDTH:CGFloat = 40.0
    static let TB_FONTSIZE:CGFloat = 40.0
}

class XHSlider: UIControl {
    
    var textField:UITextField?
    var radius:CGFloat = 0
    var angle:Int = 360
    var startColor:UIColor = UIColor.blueColor()
    var endColor:UIColor = UIColor.purpleColor()
    
    convenience init(startColor:UIColor, endColor:UIColor, frame:CGRect) {
        self.init(frame: frame)
        
        self.startColor = startColor
        self.endColor = endColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.opaque = true
        
        self.radius = self.frame.size.width/2.0 - Config.TB_SAFEAREA_PADDING
        
        let font = UIFont(name: "Avenir", size: Config.TB_FONTSIZE)
        let str:NSString = "000"
        let fontSize:CGSize = str.sizeWithAttributes([NSFontAttributeName:font!])
        
        self.textField = UITextField(frame: CGRectMake((frame.size.width - fontSize.width)/2.0, (frame.size.height - fontSize.height)/2.0, fontSize.width, fontSize.height))
        self.textField?.backgroundColor = UIColor.clearColor()
        self.textField?.textColor = UIColor(white: 1.0, alpha: 0.8)
        self.textField?.textAlignment = NSTextAlignment.Center
        self.textField?.font = font
        self.textField?.text = "\(self.angle)"
//        self.textField?.enabled = false
        
        self.addSubview(textField!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextAddArc(ctx, self.frame.size.width/2.0, self.frame.size.height/2.0, self.radius, 0, CGFloat(M_PI*2), 0)
        
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).set()
        
        CGContextSetLineWidth(ctx, 72)
        CGContextSetLineCap(ctx, CGLineCap.Butt)
        
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        
        
        
        
        
    }
    

}
