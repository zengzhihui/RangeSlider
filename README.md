# RangeSlider

## Screenshot
![](http://img1.ph.126.net/gz2fmjyVLNDVr6YAdemYHQ==/6631252483655454505.png)
##
How to use
```
### init
let kWidth: CGFloat = 300
let rangeSlider = GZRangeSlider(frame: CGRectMake(0.5 * (view.frame.width - kWidth),64,kWidth,120))

### set range add accuracy
rangeSlider.setRange(20, maxRange: 10000, accuracy: 50)

### set value change closure
rangeSlider.valueChangeClosure = {
    (left, right) -> () in
    print("left = \(left)  right = \(right) \n")
}


```