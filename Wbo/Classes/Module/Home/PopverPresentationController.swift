//
//  PopverPresentationController.swift
//  Wbo
//
//  Created by integrated on 11/4/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

class PopverPresentationController: UIPresentationController {

    /// 展现视图的大小
    var presentedFrame: CGRect = CGRectZero
    
    /// 遮罩
    lazy var coverView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGrayColor()
        v.alpha = 0.2
        let tap = UITapGestureRecognizer(target: self, action: "didClickedCoverView")
        v.addGestureRecognizer(tap)
        return v
    }()
    
    func didClickedCoverView() {
        self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView()?.frame = CGRectMake(100, 56, 200, 240)
                
        coverView.frame = containerView!.bounds
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)        
    }

}
