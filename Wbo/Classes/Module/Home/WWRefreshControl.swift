//
//  WWRefreshControl.swift
//  Wbo
//
//  Created by integrated on 11/4/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import SnapKit

class WWRefreshControl: UIRefreshControl {

    var refreshView: WWRefreshView!
    let nibName = "WWRefreshControl"
    
    /// 正在加载
    var isLoading = false
    
    /// 显示下拉箭头
    var isShowArrow = false
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    func commonInit() {
        self.refreshView = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).first as! WWRefreshView
        addSubview(self.refreshView)
        
        self.refreshView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(136, 60))
            make.top.equalTo(self.snp_top).offset(0)
            make.centerX.equalTo(self.snp_centerX).offset(0)
        }
        
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.frame.origin.y <= 0 else {
            return
        }
        
        /// 假如正在刷新加载而且正在加载
        if refreshing && !isLoading {
            refreshView.startAnimation()
            isLoading = true
            return
        }
        
        /// 还没有达到刷新的临界值
        if self.frame.origin.y < -50 && !isShowArrow{
            isShowArrow = true
            refreshView?.rotateArrow(isShowArrow)
        }else if self.frame.origin.y > -50 && isShowArrow{  // 松开返回,取消下拉动作,翻转箭头
            isShowArrow = false
            refreshView?.rotateArrow(isShowArrow)
        }
        
        
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView?.startAnimation()
        isLoading = false
    }
    

}

// MARK: - WWRefreshView

class WWRefreshView: UIView {
    
    @IBOutlet var arrowIcon: UIImageView!
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var loadingIcon: UIImageView!
    
    /// 翻转刷新时的箭头
    func rotateArrow(clockWise: Bool) {
        var angle = CGFloat(M_PI)
        angle += clockWise ? -0.01 : 0.01
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, angle)
            }) { (completion) -> Void in
                
        }
    }
    
    func startAnimation() {
        loadingView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        loadingIcon.layer.addAnimation(anim, forKey: nil)
    }
    
    func stopAnimation() {
        loadingIcon.layer.removeAllAnimations()
        loadingView.hidden = false
    }
    
}
