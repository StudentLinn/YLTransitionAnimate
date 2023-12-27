//
//  YLTransitionAnimateConfig.swift
//  YLTransitionAnimate
//
//  Created by Lin on 2023/12/22.
//

import Foundation
import UIKit

let YLAnimateManager = YLTransitionAnimateManager.shared

//MARK: 版本:0.0.5
///动画保存配置单例
public class YLTransitionAnimateManager {
    ///单例
    public static let shared = YLTransitionAnimateManager()
    
    ///配置
    public var config:YLTransitionAnimateConfig = YLTransitionAnimateConfig()
}

//MARK: 调用方法配置单例
extension YLTransitionAnimateManager {
    ///设置配置文件
    public func setConfig(_ config:((inout YLTransitionAnimateConfig) -> Void)){
        config(&self.config)
    }
}

//MARK: 使用动画
extension YLTransitionAnimateManager {
    /// 执行过渡动画
    /// - Parameters:
    ///   - view:什么控件执行
    ///   - duration: 动画执行时间->默认0.3
    ///   - delay: 动画延迟时间默认0.00
    ///   - options: 动画设置数组->默认淡入淡出首尾减速+允许同时执行
    ///   - doAfterZeroZeroOne: 是否需要延迟0.01秒与主线程拆分开来
    ///   - superViewLayoutIfNeed: 父类的布局是否需要刷新
    ///   - onceConfig: 单次配置
    ///   - typeArr: 动画类型
    ///   - animateWith: 执行动画时伴随着什么一起执行
    ///   - completion: 完成回调(传出动画是否在调用完成处理程序之前实际完成)
    public func useAnimate(view:UIView?,
                           duration:Double = 0.3,
                           delay:Double = 0.00,
                           options:UIView.AnimationOptions = [.curveEaseInOut, .beginFromCurrentState],
                           doAfterZeroZeroOne:Bool = true,
                           superViewLayoutIfNeed:Bool = true,
                           onceConfig:((inout YLTransitionAnimateConfig) -> Void)? = nil,
                           typeArr:[YLTransitionAnimateType],
                           animateWith:(() -> Void)? = nil,
                           completion:((Bool) -> Void)? = nil){
        view?.transitionAnimate(duration: duration,
                                delay: delay,
                                options: options,
                                doAfterZeroZeroOne: doAfterZeroZeroOne,
                                superViewLayoutIfNeed: superViewLayoutIfNeed,
                                onceConfig: onceConfig,
                                typeArr: typeArr,
                                animateWith: animateWith,
                                completion: completion)
    }
}

///动画配置文件
public struct YLTransitionAnimateConfig {
    ///淡入透明度 默认->1
    public var fadeInAlpha:CGFloat = 1
    ///淡出透明度 默认->0
    public var fadeOutAlpha:CGFloat = 0
    ///淡出转换到淡入关键帧时间 默认->时间的一半,0即为默认
    public var fadeRelativeTime:Double = 0
    ///上下动画偏移量 默认->屏幕高度的一半
    public var verticalTransitionPadding:CGFloat = {
        UIScreen.main.bounds.height / 2.0
    }()
    ///左右动画偏移量 默认->屏幕宽度的一半
    public var horizontalTransitionPadding:CGFloat = {
        UIScreen.main.bounds.width / 2.0
    }()
    ///缩放变小倍数 默认->0.7倍
    public var scaleToSmallMultiple:Double = 0.7
    ///缩放变大倍数 默认->1.3倍
    public var scaleToBigMultiple:Double = 1.3
    ///缩放动画第一段关键帧时间 默认->总时长的1/3
    public var scaleToSmallOneRelativeTime:Double = 0
    ///缩放动画第二段关键帧时间 默认->总时长的2/3
    public var scaleToSmallTwoRelativeTime:Double = 0
}
