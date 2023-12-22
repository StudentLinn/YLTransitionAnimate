//
//  YLTransitionAnimateConfig.swift
//  YLTransitionAnimate
//
//  Created by Lin on 2023/12/22.
//

import Foundation

///动画保存配置单例
public class YLTransitionAnimateManager {
    ///单例
    static let shared = YLTransitionAnimateManager()
    
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

///动画配置文件
public struct YLTransitionAnimateConfig {
    ///淡入透明度
    public var fadeInAlpha:CGFloat = 1
    ///淡出透明度
    public var fadeOutAlpha:CGFloat = 0
    ///上下动画偏移量
    public var verticalTransitionPadding:CGFloat = 300
    ///左右动画偏移量
    public var horizontalTransitionPadding:CGFloat = 200
    ///缩放变小倍数
    public var scaleToSmallMultiple:Double = 0.7
    ///缩放变大倍数
    public var scaleToBigMultiple:Double = 1.3
}
