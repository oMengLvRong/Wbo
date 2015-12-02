//
//  LoginView.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    
    func loginBtnClicked() -> Void
    func registerBtnClicked() -> Void
}


class LoginView: UIView {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var smallView: UIImageView!
    @IBOutlet var iconView: UIImageView!
    

    weak var delegate: LoginViewDelegate?
    
    /**
    设置未登陆时的信息
    :param: imageName 图片名
    :param: message   文本标签
    */
    func setupInfo(imgName: String, message: String, isHome: Bool = false) {
        iconView.hidden = !isHome
        messageLabel.text = message
        
        if isHome {
            iconView.image = UIImage(named: imgName)
            startAnimation()
        } else {
            smallView.image = UIImage(named: imgName)
        }
    }
    
    // 开始旋转动画
    private func startAnimation() {
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.duration = 20.0
        animate.repeatCount = MAXFLOAT
        animate.toValue = 2 * M_PI
        smallView.layer.addAnimation(animate, forKey: "rotationAnima")
    }

    @IBAction func login(sender: UIButton) {
        delegate?.loginBtnClicked()
    }
    
    @IBAction func register(sender: UIButton) {
        delegate?.registerBtnClicked()
    }
}
