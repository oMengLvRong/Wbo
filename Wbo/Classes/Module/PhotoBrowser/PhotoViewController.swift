//
//  PhotoViewController.swift
//  Wbo
//
//  Created by integrated on 11/10/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class PhotoViewController: UIViewController,UIScrollViewDelegate {
    
    /// 原始缩放比
    var scale:CGFloat = 1
    
    /// 图片的URL
    var imageUrl:NSURL?{
        didSet{
            // 下载图片
            SVProgressHUD.show()
            imageView.image = nil   // 解決collectionView復用的問題
            SDWebImageManager.sharedManager().downloadImageWithURL(imageUrl, options: SDWebImageOptions(), progress: nil) { (image, error, _, _, _) in
                SVProgressHUD.dismiss()
                if error != nil{
                    SVProgressHUD.showWithStatus("网络错误,请稍后再试")
                    return
                }
                self.setImageSize(image)
            }
        }
    }
    

    /// 滚动视图
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        return scrollView
        
        }()
    
    /// 显示图片的imageView
    lazy var imageView:UIImageView = {
        let imgV = UIImageView()
        return imgV
        }()
    
    /// 重置scrollView的一些属性
    private func resetScrollView(){
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentInset = UIEdgeInsetsZero
    }
    
    /// 计算图片尺寸
    private func setImageSize(image:UIImage){
        resetScrollView()
        let size = scaleImageSize(image)
        imageView.image = image
        imageView.frame = CGRectMake(0, 0, size.width, size.height)
        
        // 判断长短图
        if size.height > view.bounds.height{
            // 如果是长图,设置滚动区域为图片的size
            scrollView.contentSize = size
        }else{
            let top = (view.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
        }
    }
    
    /// 按照屏幕的宽度来缩放图片
    private func scaleImageSize(image:UIImage) ->CGSize{
        // 缩放比例
        let viewW = view.bounds.size.width
        let scale = image.size.width / viewW
        let imageH = image.size.height / scale
        return CGSizeMake(viewW, imageH)
    }
    
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - UIScrollView的代理方法

extension PhotoViewController {
   
    
    // 返回正在滚动的视图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    /// 结束滚动
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        // 结束滚动的时候判断缩放比例
        if scale < 1.0{ // 已经缩小了
            completeTransition(true)    // 动画完成
            return
        }
        // 如果没有缩小,重新调整视图
        let top = (scrollView.frame.height - view.frame.height) * 0.5
        if top > 0{ // 图片未超出scrollView
            scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
        }else{
            scrollView.contentInset = UIEdgeInsetsZero
        }
    }
    
    /// 正在滚动
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if imageView.transform.a < 1.0{
            scale = imageView.transform.a
            // 开始交互动画
            startInteractiveTransition(self)
        }
    }
    
}

// MARK: 交互式转场协议
extension PhotoViewController:UIViewControllerInteractiveTransitioning{
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 目标控制器和视图
        let toViewVc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewVc!.view
        
        // 创建一个快照视图并添加到主视图下面
        let snapshotView = toView.snapshotViewAfterScreenUpdates(false)
        transitionContext.containerView()!.insertSubview(snapshotView, belowSubview: view)
        // 缩放
        view.transform = CGAffineTransformMakeScale(scale, scale)
        view.alpha = scale
    }
}

extension PhotoViewController:UIViewControllerContextTransitioning{
    
    /// 转场的容器视图
    func containerView() -> UIView {
        return view.superview!
    }
    
    /// 转场动画是否结束
    func completeTransition(didComplete: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    提供一个key,返回一个控制器
    
    :param: key 有fromKey(消失)和toKey(出现)
    
    :returns: 返回切入控制器或者切出控制器
    */
    func viewControllerForKey(key: String) -> UIViewController? {
        if key == UITransitionContextToViewControllerKey{ // 目标视图控制器的key
            return UIApplication.sharedApplication().keyWindow!.rootViewController
        }else{
            return self
        }
    }
    
    // MARK: -  可以不用的函数
    func isAnimated() -> Bool {
        return true
    }
    
    func isInteractive() -> Bool {
        return true
    }
    
    func transitionWasCancelled() -> Bool {
        return false
    }
    
    func presentationStyle() -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Custom
    }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    
    func viewForKey(key: String) -> UIView? {
        return nil
    }
    
    func targetTransform() -> CGAffineTransform {
        return CGAffineTransformIdentity
    }
    
    func initialFrameForViewController(vc: UIViewController) -> CGRect {
        return CGRectZero
    }
    
    func finalFrameForViewController(vc: UIViewController) -> CGRect {
        return CGRectZero
    }
    
}
