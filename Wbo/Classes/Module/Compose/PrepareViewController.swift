//
//  PrepareViewController.swift
//  Wbo
//
//  Created by integrated on 11/18/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import DynamicBlurView
import QBImagePickerController

class PrepareViewController: VVBlurViewController, QBImagePickerControllerDelegate {

    lazy var composeVc: UINavigationController = {
        return UIStoryboard.initialViewController("Compose") as! UINavigationController
    }()
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.blurStyle = UIBlurEffectStyle.Light
    }

    @IBAction func composeStatus(sender: AnyObject) {
        presentViewController(composeVc, animated: true, completion: nil)
    }
    
    @IBAction func openAblum(sender: AnyObject) {
        let imagePicker = QBImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsMultipleSelection = true
        imagePicker.maximumNumberOfSelection = 9
        imagePicker.showsNumberOfSelectedAssets = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        
    }
    
    @IBAction func checkIn(sender: AnyObject) {
        
    }
    
    @IBAction func review(sender: AnyObject) {
        
    }
    
    @IBAction func more(sender: AnyObject) {
        
    }
    
}

// MARK: - QBImagePickerController

extension PrepareViewController {
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        /// phiimagemanger用于管理图片资源
        let imgManager = PHImageManager.defaultManager()
        let requestManager = PHImageRequestOptions()
        requestManager.resizeMode = .Exact
        requestManager.deliveryMode = .HighQualityFormat
        requestManager.networkAccessAllowed = false
        for asset in assets {
            imgManager.requestImageForAsset(asset as! PHAsset, targetSize: CGSizeMake(100, 100), contentMode: .AspectFill, options: requestManager, resultHandler: { (img, _) -> Void in
                print(img)
            })
        }
        self.view.alpha = 0
        dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(composeVc, animated: true, completion: nil)
    }
}
