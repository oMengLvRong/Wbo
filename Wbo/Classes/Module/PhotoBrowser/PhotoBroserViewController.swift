//
//  PhotoBroserViewController.swift
//  Wbo
//
//  Created by integrated on 11/9/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import SVProgressHUD

//MARK: - 自定义图片浏览器的cell
class PhotoBrowserCell: UICollectionViewCell {
    
    /// 要显示图片的url
    var imageUrl:NSURL?{
        didSet{
            viewerVc?.imageUrl = imageUrl
        }
    }
    
    /// 照片查看控制器
    var viewerVc: PhotoViewController?
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewerVc = PhotoViewController()
        viewerVc?.view.frame = bounds
        addSubview(viewerVc!.view)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("\(__FUNCTION__)")
    }
}

class PhotoBroserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var selectedIndex: Int = 0
    
    /// 大图数组
    var largeUrls:[NSURL]?
    
    let photoCellIdentifier = "photoCellIdentifier"
    
    // collectionView的布局懒加载
    lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
        }()
    
    // collectionView的懒加载
    lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        cv.dataSource = self
        cv.pagingEnabled = true
        return cv
        }()
    
    lazy var closeBtn:UIButton = {
        return self.creatButton("关闭")
        }()
    
    lazy var saveBtn:UIButton = {
        return self.creatButton("保存")
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.addSubview(collectionView)
        
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(20)
        }
        closeBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(saveBtn.snp_right).offset(10)
        }
        
        closeBtn.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.addTarget(self, action: "saveToAlbums", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func dismiss() {
        saveBtn.hidden = true
        closeBtn.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveToAlbums() {
        let photoCell = collectionView.visibleCells().last as! PhotoBrowserCell
        if let photo = photoCell.viewerVc?.imageView.image {
            UIImageWriteToSavedPhotosAlbum(photo, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        guard error != nil else {
            print(error)
            return
        }
        SVProgressHUD.showSuccessWithStatus("图片已保存!")
    }

    ///传入一个button名字来创建button
    private func creatButton(name:String) -> UIButton{
        let btn = UIButton()
        btn.setTitle(name, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.layer.borderWidth = 0.3
        btn.layer.cornerRadius = 3
        view.addSubview(btn)
        btn.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(60, 30))
            make.bottom.equalTo(view).offset(-16)
        }
        return btn
    }
    
    private func scrollToIndex() {
        let path = NSIndexPath(forItem: selectedIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    
}

extension PhotoBroserViewController {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCell
        cell.imageUrl = largeUrls![indexPath.row]
        if !childViewControllers.contains(cell.viewerVc!) {
            addChildViewController(cell.viewerVc!)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return largeUrls?.count ?? 0
    }
}


