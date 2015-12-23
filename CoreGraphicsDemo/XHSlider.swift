//
//  XHSlider.swift
//  CoreGraphicsDemo
//
//  Created by xuhui on 15/12/23.
//  Copyright © 2015年 softgoto. All rights reserved.
//

import UIKit

struct Config{
    
    static let TB_SAFEAREA_PADDING:CGFloat = 60.0
    static let TB_LINE_WIDTH:CGFloat = 40.0
    static let TB_FONTSIZE:CGFloat = 40.0
}

// MARK: Math Helpers
func DegreesToRadians (value:Double) -> Double {
    return value * M_PI / 180.0
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

func Square (value:CGFloat) -> CGFloat {
    return value * value
}

class XHSlider: UIControl {
    
    var textField:UITextField?
    var radius:CGFloat = 0
    var angle:Int = 290
    var startColor = UIColor.blueColor()
    var endColor = UIColor.purpleColor()
    
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
        self.textField?.textColor = UIColor(white: 0, alpha: 1)
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
        
        // 画背景圆
        CGContextAddArc(ctx, self.frame.size.width/2.0, self.frame.size.height/2.0, self.radius, 0, CGFloat(M_PI*2), 0)
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).set()
        CGContextSetLineWidth(ctx, 72)
        CGContextSetLineCap(ctx, CGLineCap.Butt)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        // 创建蒙版图层
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height))
        let imageCtx = UIGraphicsGetCurrentContext()
        CGContextAddArc(imageCtx, self.frame.size.width/2.0, self.frame.size.height/2.0, self.radius, 0, CGFloat(DegreesToRadians(Double(self.angle))), 0)
        UIColor.redColor().set()
        
        // 使用阴影创建模糊效果
        CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), CGFloat(self.angle/15), UIColor.blackColor().CGColor)
        
        // 定义路径
        CGContextSetLineWidth(imageCtx, Config.TB_LINE_WIDTH)
        CGContextDrawPath(imageCtx, CGPathDrawingMode.Stroke)
        
        // 保存上下文内容为 mask
        let mask:CGImageRef? = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext()
        
        CGContextSaveGState(ctx)
        CGContextClipToMask(ctx, self.bounds, mask!)
        
        
        //绘制渐变
        
        //定义渐变的颜色
        let startColorComps:UnsafePointer<CGFloat> = CGColorGetComponents(self.startColor.CGColor)
        let endColorComps:UnsafePointer<CGFloat> = CGColorGetComponents(self.endColor.CGColor)
        let components:[CGFloat] = [
            startColorComps[0], startColorComps[1], startColorComps[2], 1.0,    //开始颜色
            endColorComps[0], endColorComps[1], endColorComps[2], 1.0,          //结束颜色
        ]
        
        //创建颜色空间
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(baseSpace, components, nil, 2)
        
        //指定渐变位置
        let startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        let endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        
        //绘制渐变
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsBeforeStartLocation)
        CGContextRestoreGState(ctx)
        
        self.drawTheHandle(ctx!)
        
    }
    
    //画点
    func drawTheHandle(ctx:CGContextRef) {
        CGContextSaveGState(ctx)
        
        //设置阴影
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, UIColor.blackColor().CGColor)
        
        //得到点的坐标
        let handleCenter = self.pointFromAngle(self.angle)
        
        UIColor(white: 1.0, alpha: 0.7).set()
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, Config.TB_LINE_WIDTH, Config.TB_LINE_WIDTH))
        CGContextRestoreGState(ctx)
    }
    
    //根据角度计算点在圆上的位置
    func pointFromAngle(angleInt:Int) -> CGPoint {
        //先拿到圆点位置
        let centerPoint = CGPointMake(self.frame.size.width/2.0 - Config.TB_LINE_WIDTH/2.0, self.frame.size.height/2.0 - Config.TB_LINE_WIDTH/2.0)
        
        //圆圈上的点
        var result:CGPoint = CGPointZero
        let y = round(Double(radius) * sin(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.y)
        let x = round(Double(radius) * cos(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.x)
        
        result.y = CGFloat(y)
        result.x = CGFloat(x)
        
        return result
    }
    
    //移动
    func moveHandle(lastPoint: CGPoint) {
        //中心点
        let centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        //计算从中心到方向随意位置的方向
        let currentAngle:Double = AngleFromNorth(centerPoint, p2: lastPoint, flipped: false);
        let angleInt = Int(floor(currentAngle))
        
        // 存储新的角度
        angle = Int(360 - angleInt)
        
        // 更新 textfiled
        textField!.text = "\(angle)"
        
        // 重绘
        setNeedsDisplay()
        
    }
    
    
    //开启触摸
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        return true
    }
    
    //持续跟踪触摸事件
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        let lastPoint = touch.locationInView(self)
        
        self.moveHandle(lastPoint)
        
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }

    
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> Double {
        var v:CGPoint  = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let vmag:CGFloat = Square(Square(v.x) + Square(v.y))
        var result:Double = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = Double(atan2(v.y,v.x))
        result = RadiansToDegrees(radians)
        return (result >= 0  ? result : result + 360.0);
    }
}
