//
//  UIView.swift
//  YLTransitionAnimate
//
//  Created by Lin on 2023/12/22.
//

import UIKit
import SnapKit

///过渡动画类型(移动位置的话需要有snp并且设置了centerY或者X属性)
public enum YLTransitionAnimateType : Int {
    ///淡入（修改透明度）
    case fadeIn = 1
    ///淡出（修改透明度）
    case fadeOut = 2
    ///淡出后又淡入
    case fadeOutAndIn = 3
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
}

//MARK: 动画效果
extension UIView {
    /// 执行过渡动画
    /// - Parameters:
    ///   - duration: 动画执行时间->默认0.3
    ///   - delay: 动画延迟时间默认0.00
    ///   - options: 动画设置数组->默认淡入淡出首尾减速+允许同时执行
    ///   - doAfterZeroZeroOne: 是否需要延迟0.01秒与主线程拆分开来
    ///   - superViewLayoutIfNeed: 父类的布局是否需要刷新
    ///   - onceConfig:单次配置
    ///   - type: 动画类型
    ///   - animateWith: 执行动画时伴随着什么一起执行
    ///   - completion: 完成回调(传出动画是否在调用完成处理程序之前实际完成)
    public func transitionAnimate(duration:Double = 0.3,
                                  delay:Double = 0.00,
                                  options:AnimationOptions = [.curveEaseInOut, .beginFromCurrentState],
                                  doAfterZeroZeroOne:Bool = true,
                                  superViewLayoutIfNeed:Bool = true,
                                  onceConfig:((inout YLTransitionAnimateConfig) -> Void)? = nil,
                                  typeArr:[YLTransitionAnimateType],
                                  animateWith:(() -> Void)? = nil,
                                  completion:((Bool) -> Void)? = nil){
        //记录配置
        let config = YLTransitionAnimateManager.shared.config
        //如果有单次设置
        if let onceConfig = onceConfig {
            //修改
            onceConfig(&YLTransitionAnimateManager.shared.config)
        }
        //是否与主线程拆分开来
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (doAfterZeroZeroOne ? 0.01 : 0)) {
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
                //刷新布局
                superViewLayoutIfNeed ? superview?.layoutIfNeeded() : layoutIfNeeded()
            } completion: { success in
                //如果有使用单次配置
                if onceConfig != nil {
                    //还原配置
                    YLTransitionAnimateManager.shared.config = config
                }
                completion?(success)
            }
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
        case .transToTop : //移动到顶部
            snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-config.verticalTransitionPadding)
            }
        case .transToBottom : //移动到底部
            snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(config.verticalTransitionPadding)
            }
        case .transToLeft : //移动到左边
            snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(-config.horizontalTransitionPadding)
            }
        case .transToRight : //移动到右边
            snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(config.horizontalTransitionPadding)
            }
        case .transToCenter : //移动到中心点
            snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
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
