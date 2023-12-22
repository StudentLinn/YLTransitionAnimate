//
//  ViewController.swift
//  YLTransitionAnimate
//
//  Created by Lin on 2023/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var btn = UIButton()
    lazy var testView = UIView()
    var test = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.setTitle("点击", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        testView.backgroundColor = .black.withAlphaComponent(0.5)
        testView.layer.cornerRadius = 50
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        YLTransitionAnimateManager.shared.setConfig { config in
            //偏移高度
            config.verticalTransitionPadding = 500
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
        testView.transitionAnimate(typeArr: [.transInFromBottom], completion:  { [weak self] success in
            self?.testView.alpha = 1
        })
    }
}
