//
//  UIView.swift
//  YLTransitionAnimate
//
//  Created by Lin on 2023/12/22.
//

import UIKit

///过渡动画类型
public enum YLTransitionAnimateType : Int {
    ///淡入（修改透明度）
    case fadeIn = 1
    ///淡出（修改透明度）
    case fadeOut = 2
    ///淡出后又淡入
    case fadeOutAndIn = 3
    ///向上移动半屏
    case transToTop = 4
    ///向下移动半屏
    case transToBottom = 5
    ///向左移动半屏
    case transToLeft = 6
    ///向右移动半屏
    case transToRight = 7
    ///缩放动画(变小后变大)
    case scaleFromSmall = 8
    ///缩放动画(变大后变小)
    case scaleFromBig = 9
}

//MARK: 动画效果
extension UIView {
    /// 执行过渡动画
    /// - Parameters:
    ///   - duration: 动画执行时间->默认0.3
    ///   - delay: 动画延迟时间默认0.05
    ///   - options: 动画设置数组->默认淡入淡出首尾减速+允许同时执行
    ///   - type: 动画类型
    ///   - animateWith: 执行动画时伴随着什么一起执行
    ///   - completion: 完成回调(传出动画是否在调用完成处理程序之前实际完成)
    public func transitionAnimate(duration:Double = 0.3,
                                  delay:Double = 0.01,
                                  options:AnimationOptions = [.curveEaseInOut, .beginFromCurrentState],
                                  typeArr:[YLTransitionAnimateType],
                                  animateWith:(() -> Void)? = nil,
                                  completion:((Bool) -> Void)? = nil){
        //延迟delay秒后执行持续duration时间动画设置效果为options
        UIView.animate(withDuration: duration, delay: delay, options: options) { [weak self] in
            guard let self else { return }
            //需要执行什么类型的动画
            animateWith?()
            //遍历需要执行的动画数组并执行
            for type in typeArr {
                //传入动画持续时间和需要执行的操作
                YLTypeAnimateDo(duration: duration, type: type)
            }
            superview?.layoutIfNeeded()
        } completion: { success in
            completion?(success)
        }
        
        
    }
    
    /// 各动画效果
    /// - Parameter duration: 传入动画时间
    /// - Parameter type: 根据传入类型执行对应动画
    private func YLTypeAnimateDo(duration:Double,
                                type: YLTransitionAnimateType){
        //持续时间0不执行
        if duration == 0 {
            return
        }
        //获取配置文件
        let config = YLTransitionAnimateManager.shared.config
        //判断类型
        switch type {
        case .fadeIn : //淡入
            alpha = config.fadeInAlpha
        case .fadeOut : //淡出
            alpha = config.fadeOutAlpha
        case .fadeOutAndIn : //淡出后淡出
            ///获取关键帧时间,0为默认(总时长的一半)
            let keyTime = (config.fadeRelativeTime == 0) ? duration / 2.0 : config.fadeRelativeTime
            //添加关键帧0~1/2时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration:keyTime) {
                //淡出
                self.alpha = config.fadeOutAlpha
            }
            //添加关键帧1/2时间~结束
            UIView.addKeyframe(withRelativeStartTime: keyTime, relativeDuration: duration) {
                self.alpha = config.fadeInAlpha
            }
        case .transToTop : //从下向上
            center.y -= config.verticalTransitionPadding
        case .transToBottom : //从上向下
            center.y += config.verticalTransitionPadding
        case .transToRight : //从左向右
            center.x += config.horizontalTransitionPadding
        case .transToLeft : //从右向左
            center.x -= config.horizontalTransitionPadding
        case .scaleFromSmall : //缩放动画从小到大
            //记录初始值
            let transForm = self.transform
            //第一段关键帧时间
            let oneTime = (config.scaleToSmallOneRelativeTime == 0) ? duration / 3.0 : config.scaleToSmallOneRelativeTime
            //第二段关键帧时间
            let twoTime = (config.scaleToSmallTwoRelativeTime == 0) ? duration / 3.0 : config.scaleToSmallTwoRelativeTime
            //添加关键帧0~1/3时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: oneTime) {
                //变小
                self.transform = transForm.scaledBy(x: config.scaleToSmallMultiple,
                                                    y: config.scaleToSmallMultiple)
            }
            //添加关键帧1/3时间~2/3
            UIView.addKeyframe(withRelativeStartTime: oneTime, relativeDuration: twoTime) {
                self.transform = transForm.scaledBy(x: config.scaleToBigMultiple,
                                                    y: config.scaleToBigMultiple)
            }
            //最后在2/3时间~结束时间变回初始
            UIView.addKeyframe(withRelativeStartTime: twoTime, relativeDuration: duration) {
                self.transform = transForm
            }
        case .scaleFromBig : //缩放动画从大到小
            //记录初始值
            let transForm = self.transform
            //第一段关键帧时间
            let oneTime = (config.scaleToSmallOneRelativeTime == 0) ? duration / 3.0 : config.scaleToSmallOneRelativeTime
            //第二段关键帧时间
            let twoTime = (config.scaleToSmallTwoRelativeTime == 0) ? duration / 3.0 : config.scaleToSmallTwoRelativeTime
            //添加关键帧0~1/3时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: oneTime) {
                //变小
                self.transform = transForm.scaledBy(x: config.scaleToBigMultiple,
                                                    y: config.scaleToBigMultiple)
            }
            //添加关键帧1/3时间~2/3
            UIView.addKeyframe(withRelativeStartTime: oneTime, relativeDuration: twoTime) {
                self.transform = transForm.scaledBy(x: config.scaleToSmallMultiple,
                                                    y: config.scaleToSmallMultiple)
            }
            //最后在2/3时间~结束时间变回初始
            UIView.addKeyframe(withRelativeStartTime: twoTime, relativeDuration: duration) {
                self.transform = transForm
            }
        }
    }
}
