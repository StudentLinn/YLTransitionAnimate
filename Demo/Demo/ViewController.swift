//
//  ViewController.swift
//  Demo
//
//  Created by Lin on 2023/12/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: 测试数据
    var test = 0
    var testTwo = 0
    
    //MARK: 控件相关
    ///移动按钮
    lazy var moveBtn = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.tag = 1
        btn.setTitle("点击移动", for: .normal)
        return btn
    }()
    ///点击按钮
    lazy var clickBtn = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.tag = 2
        btn.setTitle("点击反馈", for: .normal)
        return btn
    }()
    ///点击按钮展示蒙层
    lazy var addMaskBtn = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.tag = 3
        btn.setTitle("点击弹出", for: .normal)
        return btn
    }()
    ///展示View
    lazy var testView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 50
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //移动按钮
        view.addSubview(moveBtn)
        moveBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        //点击反馈按钮
        view.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.leading.equalTo(moveBtn)
        }
        //展示蒙层按钮
        view.addSubview(addMaskBtn)
        addMaskBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(100)
            make.width.height.leading.equalTo(addMaskBtn)
        }
        //动画展示圆球
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height / 2.0)
            make.width.height.equalTo(100)
        }
        
    }


}


extension ViewController{
    //点击移动按钮
    @objc func click(_ btn:UIButton){
        //点击移动按钮
        if btn.tag == 1 {
            if test < 0 {
                test += 100
            } else {
                test -= 100
            }
            //
            testView.transitionAnimate(typeArr: [test < 0 ? .transToTop : .transToBottom], completion:  { [weak self] success in
                self?.testView.alpha = 1
            })
        } else if btn.tag == 2 {
            //点击震动反馈按钮
            if testTwo < 0 {
                testTwo += 100
            } else {
                testTwo -= 100
            }
            //
            testView.transitionAnimate(typeArr: testTwo < 0 ? [.fadeIn, .scaleFromBig] : [.fadeOut, .scaleFromSmall], completion:  { [weak self] success in
                self?.testView.alpha = 1
            })
            
            YLAnimateManager.useAnimate(view: testView, typeArr: [.fadeOut], completion:  { [weak self] success in
                guard let self else { return }
                testView.transitionAnimate(typeArr: [.fadeIn])
            })
        } else if btn.tag == 3 {
            //点击展示蒙层按钮
            ///蒙层测试
            let maskTestView = MaskTestView()
            //添加并执行动画
            maskTestView.addToView(view: view)
        }
    }
    
}


public class MaskTestView:UIView {
    let userView = UIView()
    let btn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //蒙层
        backgroundColor = .black.withAlphaComponent(0.5)
        userView.backgroundColor = .white
        userView.layer.cornerRadius = 12
        addSubview(userView)
        addSubview(btn)
        userView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(UIScreen.main.bounds.height / 2.0)
            make.width.height.equalTo(100)
        }
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func btnClick(){
        //向下移动完成后移除
        userView.transitionAnimate(typeArr: [.transToBottom], completion:  { success in
            self.removeFromSuperview()
        })
    }
    ///添加到什么View上+执行进入动画
    public func addToView(view:UIView?){
        guard let view else { return }
        view.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //交互框向上移动
        userView.transitionAnimate(typeArr: [.transToTop])
    }
}
