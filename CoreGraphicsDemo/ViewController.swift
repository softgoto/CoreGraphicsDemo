//
//  ViewController.swift
//  CoreGraphicsDemo
//
//  Created by xuhui on 15/12/23.
//  Copyright © 2015年 softgoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.backgroundColor = UIColor.blackColor()
        let slider:XHSlider = XHSlider(startColor: UIColor.grayColor(), endColor: UIColor.greenColor(), frame: self.view.bounds)
        
        self.view.addSubview(slider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

