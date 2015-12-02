//
//  ComposeViewController.swift
//  Wbo
//
//  Created by integrated on 11/17/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import QBImagePickerController

private let size = (UIScreen.mainScreen().bounds.width - (2 * 10) - (2 * 5)) / 3

class ComposeViewController: UIViewController, UITextViewDelegate, QBImagePickerControllerDelegate, UICollectionViewDataSource {

    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var sendBtn: UIBarButtonItem!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var toolBarBottomConstraint: NSLayoutConstraint!
    
    @IBAction func dismiss(sender: AnyObject) {
        var vc: UIViewController? = self
        
        while(vc?.presentingViewController != nil) {
            vc = vc?.presentingViewController
        }
        
        vc?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openAlbum(sender: AnyObject) {
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.maximumNumberOfSelection = 9
        imagePickerController.showsNumberOfSelectedAssets = true
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func composeStatus(sender: AnyObject) {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let params = ["access_token": shareUserAccount!.access_token,
            "status": textView.text]
        NetworkTool.requestJSON(.POST, URLString: urlString, params: params) { (JSON) -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    let statusMaxLength = 140
    
    let rowMargin: CGFloat = 5
    
    var photoArray: [UIImage] = []
    
    let photoCellIdentifiler = "photoCellIdentifiler"
    
    /// 占位文字
    lazy var placeholderLabel: UILabel = {
        let pl = UILabel(frame: CGRectMake(5, 8, 0, 0))
        pl.text = "请输入文字..."
        pl.font = UIFont.systemFontOfSize(18)
        pl.textColor = UIColor.lightGrayColor()
        pl.sizeToFit()
        return pl
    }()
    
    /// collectionView布局
    lazy var layout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = UICollectionViewScrollDirection.Vertical
        l.itemSize = CGSizeMake(size, size)
        l.minimumInteritemSpacing = self.rowMargin
        l.minimumLineSpacing = self.rowMargin
        return l
    }()
    
    lazy var photoView: UICollectionView = {
        let pV = UICollectionView(frame: CGRectMake(0, 150, UIScreen.mainScreen().bounds.width - 20, 3 * size + 2 * self.rowMargin), collectionViewLayout: self.layout)
        pV.frame.origin.y = 150
        pV.backgroundColor = UIColor.whiteColor()
        pV.dataSource = self
        return pV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoti()
        setupUI()
    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setupNoti() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        nameLabel.text = shareUserAccount?.name
        textView.addSubview(placeholderLabel)
        photoView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: photoCellIdentifiler)
        view.insertSubview(photoView, belowSubview: toolBar)
    }

}

// MARK: - About Keyboard

extension ComposeViewController {
    func keyboardChanged(noti: NSNotification) {
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        var height:CGFloat = 0
        if noti.name == UIKeyboardWillChangeFrameNotification {
            let frame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            height = frame.height
        }
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolBarBottomConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - textViewDelegate

extension ComposeViewController {
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        sendBtn.enabled = textView.hasText()
        
        let text = textView.text as NSString
        
        if text.length > statusMaxLength {
            textView.text = text.substringToIndex(statusMaxLength)
        }
    }
}

// MARK: - QBImagePickerControllerDelegate

extension ComposeViewController {
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let imgManager = PHImageManager.defaultManager()
        let requestOption = PHImageRequestOptions()
        requestOption.resizeMode = .Exact
        requestOption.deliveryMode = .HighQualityFormat
        requestOption.synchronous = false
        requestOption.networkAccessAllowed = true
        for asset in assets {
            imgManager.requestImageForAsset(asset as! PHAsset, targetSize: CGSizeMake(100, 100), contentMode: PHImageContentMode.AspectFill, options: requestOption, resultHandler: { (image, _) -> Void in
                self.photoArray.append(image!)
                self.photoView.reloadData()
            })
        }
        dismissViewControllerAnimated(false, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ComposeViewController {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifiler, forIndexPath: indexPath) as! PhotoCell
        
//        for img in photoArray! {
            cell.imageView.image = photoArray[indexPath.row]
//        }
        
        return cell
    }
}

class PhotoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.imageView.frame = CGRectMake(0, 0, size, size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var imageView = UIImageView()
}
