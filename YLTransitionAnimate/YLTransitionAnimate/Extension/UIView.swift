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
    ///从下向上动画
    case transInFromBottom = 4
    ///从上向下动画
    case transInFromTop = 5
    ///从左向右动画
    case transInFromLeading = 6
    ///从右向左动画
    case transInFromTrailing = 7
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
    ///   - options: 动画设置数组->默认淡入淡出首尾减速
    ///   - type: 动画类型
    ///   - animateWith: 执行动画时伴随着什么一起执行
    ///   - completion: 完成回调(传出动画是否在调用完成处理程序之前实际完成)
    public func transitionAnimate(duration:Double = 0.3,
                                  delay:Double = 0.01,
                                  options:AnimationOptions = [.curveEaseInOut],
                                  typeArr:[YLTransitionAnimateType],
                                  animateWith:(() -> Void)? = nil,
                                  completion:((Bool) -> Void)? = nil){
        //持续时间0不执行
        if duration == 0 {
            return
        }
//        //先执行动画开始之前所需的操作
//        for type in typeArr {
//            YLTypeAnimateDoWithStart(type)
//        }
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
    public func YLTypeAnimateDo(duration:Double,
                                type: YLTransitionAnimateType){
        let config = YLTransitionAnimateManager.shared.config
        //判断类型
        switch type {
        case .fadeIn : //淡入
            alpha = config.fadeInAlpha
        case .fadeOut : //淡出
            alpha = config.fadeOutAlpha
        case .fadeOutAndIn : //淡出后淡出
            //添加关键帧0~1/2时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2.0) {
                //淡出
                self.alpha = config.fadeOutAlpha
            }
            //添加关键帧1/2时间~结束
            UIView.addKeyframe(withRelativeStartTime: duration / 2.0, relativeDuration: duration) {
                self.alpha = config.fadeInAlpha
            }
        case .transInFromBottom : //从下向上
            center.y -= config.verticalTransitionPadding
        case .transInFromTop : //从上向下
            center.y += config.verticalTransitionPadding
        case .transInFromLeading : //从左向右
            center.x += config.horizontalTransitionPadding
        case .transInFromTrailing : //从右向左
            center.x -= config.horizontalTransitionPadding
        case .scaleFromSmall : //缩放动画从小到大
            //记录初始值
            let transForm = self.transform
            //添加关键帧0~1/3时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 3.0) {
                //变小
                self.transform = transForm.scaledBy(x: config.scaleToSmallMultiple,
                                                    y: config.scaleToSmallMultiple)
            }
            //添加关键帧1/3时间~2/3
            UIView.addKeyframe(withRelativeStartTime: duration / 3.0, relativeDuration: duration / 3.0 * 2) {
                self.transform = transForm.scaledBy(x: config.scaleToBigMultiple,
                                                    y: config.scaleToBigMultiple)
            }
            //最后在2/3时间~结束时间变回初始
            UIView.addKeyframe(withRelativeStartTime: duration * 2 / 3.0, relativeDuration: duration) {
                self.transform = transForm
            }
        case .scaleFromBig : //缩放动画从大到小
            //记录初始值
            let transForm = self.transform
            //添加关键帧0~1/3时间
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 3.0) {
                //变小
                self.transform = transForm.scaledBy(x: config.scaleToBigMultiple,
                                                    y: config.scaleToBigMultiple)
            }
            //添加关键帧1/3时间~2/3
            UIView.addKeyframe(withRelativeStartTime: duration / 3.0, relativeDuration: duration / 3.0 * 2) {
                self.transform = transForm.scaledBy(x: config.scaleToSmallMultiple,
                                                    y: config.scaleToSmallMultiple)
            }
            //最后在2/3时间~结束时间变回初始
            UIView.addKeyframe(withRelativeStartTime: duration * 2 / 3.0, relativeDuration: duration) {
                self.transform = transForm
            }
        }
    }
    
    
    /// 各动画开始时间
    /// - Parameter type: 类型
    public func YLTypeAnimateDoWithStart(_ type: YLTransitionAnimateType){
        let config = YLTransitionAnimateManager.shared.config
        //判断类型
        switch type {
        case .fadeIn : //淡入
            break
        case .fadeOut : //淡出
            break
        case .transInFromBottom : //从下向上
            center.y += config.verticalTransitionPadding
        case .transInFromTop : //从上向下
            center.y -= config.verticalTransitionPadding
        case .transInFromLeading : //从左向右
            center.x -= 200
        case .transInFromTrailing : //从右向左
            center.x += 200
        default : break //其他
        }
    }
}
