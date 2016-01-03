# RangeSlider
A number value range slider made by Swift

## Screenshot
![](http://img1.ph.126.net/gz2fmjyVLNDVr6YAdemYHQ==/6631252483655454505.png)

##
How to use

Add GZRangeSlider.swift to your project

```
//init
let kWidth: CGFloat = 300
let rangeSlider = GZRangeSlider(frame: CGRectMake(0.5 * (view.frame.width - kWidth),64,kWidth,120))

//set range and accuracy
rangeSlider.setRange(20, maxRange: 10000, accuracy: 50)

//set value change closure
rangeSlider.valueChangeClosure = {
    (left, right) -> () in
    print("left = \(left)  right = \(right) \n")
}


```