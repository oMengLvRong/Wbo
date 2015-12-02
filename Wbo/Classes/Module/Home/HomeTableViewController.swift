//
//  HomeTableViewController.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController, StatusCellDelegate {
    
    @IBAction func HomeTitleClicked(sender: AnyObject) {
        performSegueWithIdentifier("home2Popover", sender: nil)
    }
    
    @IBOutlet var titleBtn: HomeTitleButton!
    
    /// 顶部按钮转场动画的代理
    let animationDelegate = PopoverAnimation()
    
    /// 照片浏览器专场动画的代理
    let photoAnimate = PhotoBroserAnimation()
    
    /// 上拉刷新标志
    var pullupRefreshFlag = false
    
    var statuses: [Status]?{
        didSet{
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupTitleBtn()
        
        if login {
            
            setupRefresh()
            
        }
        
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PopViewController {
            vc.transitioningDelegate = animationDelegate
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            let x = (self.view.bounds.width - 200) * 0.5
            animationDelegate.presentedFrame = CGRectMake(x, 56, 200, 240)
        }
    }
    

    // MARK: - Private methods
   
    func setupTitleBtn() {
        if shareUserAccount != nil {
            titleBtn.setTitle(shareUserAccount!.name + " ", forState: UIControlState.Normal)
        } else {
            titleBtn.setImage(nil, forState: UIControlState.Normal)
        }
        
        if titleBtn.state == UIControlState.Selected{
            
            // TODO: -
        }

    }
    
    func setupRefresh() {
        self.refreshControl = WWRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        loadData()
    }
  
    func loadData() {
        
        refreshControl?.beginRefreshing()
        
        // TODO: - 先判断是上拉刷新还是下拉刷新
        
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 说明时上拉刷新
        if pullupRefreshFlag == true {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        // TODO: - 加载数据
        Status.loadStatus(since_id: since_id, max_id: max_id) { (statuses) -> () in
            if statuses == nil{
                self.refreshControl?.endRefreshing()
                return
            }
            
            // 如果since_id > 0,说明有新数据,要把新数据放到现在有数据最前面
            if since_id < 0 {
                self.statuses = statuses! + self.statuses!
            }else if max_id > 0 { // 说明上拉有旧数据,要把旧数据放到现有数据的后面
                self.statuses! += statuses!
                self.pullupRefreshFlag = false
            }else{
                self.statuses = statuses
            }
            
//            self.refreshControl?.endRefreshing()
        }
    }

}


// MARK: - Table view data source

extension HomeTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 得到当前cell的status
        let status = self.statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCell.getCellIdentifier(status), forIndexPath: indexPath) as! StatusCell
        
        // Configure the cell...
        cell.setCell(status)
        cell.delegate = self
        
        // 如果cell现实到最后一行,并且没有上拉刷新
        if indexPath.row == (statuses!.count - 1) && !pullupRefreshFlag{
            pullupRefreshFlag = true
            loadData()
        }
        
        return cell
    }
}

// MARK: - StatusCellDelegate``

extension HomeTableViewController {
    
    func didSelectedPicture(cell: StatusCell, pictureCell: PictureCell, index: Int) {
        
        let broser = PhotoBroserViewController()
        broser.transitioningDelegate = photoAnimate
        broser.modalPresentationStyle = UIModalPresentationStyle.Custom
        broser.selectedIndex = index
        
        // 临时装载图片的view
        photoAnimate.tempView = pictureCell.snapshotViewAfterScreenUpdates(false)
        // 点击图片cell在控制器View上的frame
        var rect = pictureCell.frame
        rect = cell.convertRect(rect, fromView: cell.picCollectionView)
        rect = self.view.convertRect(rect, fromView: cell)
        
        // 当tableview往下拉的时候，坐标会因为contentoffset增加而增加
        rect = CGRectOffset(rect, 0, self.tableView.contentOffset.y)
        photoAnimate.tempView?.frame = rect
        photoAnimate.tempViewStartRect = rect
        
        print(pictureCell.picView.image?.size)
        
        // end rect frame
        photoAnimate.tempViewEndRect = scaleImageRect(pictureCell.picView.image!)
        
        // 传递数据
        broser.largeUrls = cell.status.largePicURLs
        presentViewController(broser, animated: true, completion: nil)
    }
    
    private func scaleImageRect(image: UIImage) -> CGRect {
        let viewW = self.view.bounds.width
        let scale = image.size.width / viewW
        var imageH = image.size.height / scale
        var imageY: CGFloat = 0
        
        /// 判断长短图
        if imageH > view.bounds.height{
            imageH = view.bounds.height
        }else{
            imageY = (view.bounds.height - imageH) * 0.5
        }
        
        return CGRectMake(0, imageY, viewW, imageH)
    }
}
