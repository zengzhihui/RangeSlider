//
//  ViewController.swift
//  RangeSlider
//
//  Created by zzh on 16/1/3.
//  Copyright © 2016年 Gavin Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let kWidth: CGFloat = 300
        let rangeSlider = GZRangeSlider(frame: CGRectMake(0.5 * (view.frame.width - kWidth),64,kWidth,120))
rangeSlider.setRange(20, maxRange: 10000, accuracy: 50)
rangeSlider.valueChangeClosure = {
    (left, right) -> () in
    print("left = \(left)  right = \(right) \n")
}
        view.addSubview(rangeSlider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

