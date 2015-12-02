//
//  PhotoBroserAnimation.swift
//  Wbo
//
//  Created by integrated on 11/9/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

class PhotoBroserAnimation: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{

    var isPresent = false
    
    var tempView: UIView?
    
    var tempViewStartRect = CGRectZero
    
    var tempViewEndRect = CGRectZero
    
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
  
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /// 规定转场时间`
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }

    // transitionContext 提供了转场的细节
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(transitionContext)
        
        if isPresent { // present
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                // 添加到容器视图中
                transitionContext.containerView()?.addSubview(tempView!)
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.tempView?.frame = self.tempViewEndRect
                }, completion: { (icCompleted) -> Void in
                    // 表示转场结束
                    self.tempView?.removeFromSuperview()
                    // 添加toView,是因为toView上有一个dismiss掉当前view的按钮
                    transitionContext.containerView()?.addSubview(toView)
                    transitionContext.completeTransition(true)
                })
            }
        } else { // dismiss
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            let fromVc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! PhotoBroserViewController
            let pictureCell = fromVc.collectionView.visibleCells().last as! PhotoBrowserCell
            let imgView = pictureCell.viewerVc!.view
            
            // catch a snopView
            let snapView = imgView.snapshotViewAfterScreenUpdates(false)
            let rect = CGRectMake(CGRectGetMidX(tempViewStartRect), CGRectGetMidY(tempViewStartRect), 0, 0)
            transitionContext.containerView()?.addSubview(snapView)
            
            fromView?.hidden = true
            UIView.animateWithDuration(duration, animations: { () -> Void in
                snapView.frame = rect
            }, completion: { (isCompleted) -> Void in
                transitionContext.completeTransition(true)
            })
        }
        
    }
    
}
