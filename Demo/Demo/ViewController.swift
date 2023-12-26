//
//  ViewController.swift
//  Demo
//
//  Created by Lin on 2023/12/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var btn = UIButton()
    lazy var btntwo = UIButton()
    lazy var testView = UIView()
    var test = 0
    var testTwo = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //第一个按钮
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.setTitle("点击移动", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        //第二个按钮
        btntwo.backgroundColor = .black
        btntwo.addTarget(self, action: #selector(twoClick), for: .touchUpInside)
        btntwo.setTitle("点击反馈", for: .normal)
        view.addSubview(btntwo)
        btntwo.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.height.equalTo(100)
        }
        //动画展示圆球
        testView.backgroundColor = .black.withAlphaComponent(0.5)
        testView.layer.cornerRadius = 50
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
    }


}


extension ViewController{
    @objc func click(){
        if test < 0 {
            test += 100
        } else {
            test -= 100
        }
        //
        testView.transitionAnimate(typeArr: [test < 0 ? .transToTop : .transToBottom], completion:  { [weak self] success in
            self?.testView.alpha = 1
        })
    }
    @objc func twoClick(){
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
        
    }
}
