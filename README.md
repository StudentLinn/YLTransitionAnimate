# YLTransitionAnimate

## 自己日常使用的过渡动画

## 初步使用
```swift
//修改淡入淡出透明度、移动距离、缩放倍数配置
YLAnimateManager.setConfig
```

## YLTransitionAnimateType可以查看动画类型
```swift
///淡入（修改透明度）
case fadeIn = 1
///淡出（修改透明度）
case fadeOut = 2
///淡出后又淡入
case fadeOutAndIn = 3
(移动位置的话需要有snp并且设置了centerY或者X属性)
///移动到顶部
case transToTop = 4
///移动到底部
case transToBottom = 5
///移动到左边
case transToLeft = 6
///移动到右边
case transToRight = 7
///移动到中心点
case transToCenter = 8
///缩放动画(变小后变大)
case scaleFromSmall = 9
///缩放动画(变大后变小)
case scaleFromBig = 10
```

## 如何使用
```swift
//两种调用方法
YLAnimateManager.useAnimate(view: testView, typeArr: [.fadeOut], completion:  { [weak self] success in
    guard let self else { return }
    testView.transitionAnimate(typeArr: [.fadeIn])
})
```
