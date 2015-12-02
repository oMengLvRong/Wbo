//
//  StatusCell.swift
//  Wbo
//
//  Created by integrated on 11/3/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

protocol StatusCellDelegate: class {
    // 声明代理方法
    /**
    选择cell中的的照片
    */
    func didSelectedPicture(cell:StatusCell,pictureCell:PictureCell,index:Int)
}

class StatusCell: UITableViewCell {

    // 头像
    @IBOutlet var iconImage: UIImageView!
    
    // 认证图标
    @IBOutlet var verifiedImage: UIImageView!
    
    // 名称
    @IBOutlet var nameLabel: UILabel!
    
    // vip等级
    @IBOutlet var vipRankIamge: UIImageView!
    
    // 时间
    @IBOutlet var timeLabel: UILabel!
    
    // 来源
    @IBOutlet var sourceLabel: UILabel!
    
    // 内容
    @IBOutlet var content: YYLabel!
    
    // 转发内容,只有转发微博才有
    @IBOutlet var forwardLabel: YYLabel!
    
    // 配图容器
    @IBOutlet var picCollectionView: UICollectionView!
    
    @IBOutlet var picViewWidth: NSLayoutConstraint!
    
    @IBOutlet var picViewHeight: NSLayoutConstraint!
    
    weak var delegate: StatusCellDelegate?
    
    /////////////////////////////////////
    
    let helper = StatusHelper.shareInstance
    
    var status: Status! {
        didSet{
            iconImage.sd_setImageWithURL(status.user?.iconURL)
            nameLabel.text = status.user?.name
            timeLabel.text = helper.stringWithTimelineDate(status.created_at)
            sourceLabel.text = helper.stringWithSource(status.source)
            content.text = status.text
            vipRankIamge.image = status.user?.vipRankIamge
//            verifiedImage.image = status.user?.verifiedTypeImage
            forwardLabel?.text = (status.retweeted_status?.user?.name ?? "") + ":" + (status.retweeted_status?.text ?? "")
            
            let picsSize = getPicViewSize(status.pictureURLs?.count ?? 0)
            picViewWidth.constant = picsSize.width
            picViewHeight.constant = picsSize.height
            
            picCollectionView.reloadData()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    // 判断是什么类型的cell
    static func getCellIdentifier(status: Status) -> String {
        return status.retweeted_status == nil ? "HomeCell" : "ForwardCell"
    }
    
    // 计算配图容器尺寸
    private func getPicViewSize(picCount: Int) -> CGSize {
        
        let itemSize = 90
        let padding = 10
        
        let h: CGFloat
        let w: CGFloat
     
        if picCount == 0 {
            h = 0
            w = 0
        } else if picCount > 0 && picCount < 4 {
            h = CGFloat(itemSize + padding)
            w = CGFloat(padding * (picCount - 1) + itemSize * picCount)
        } else if picCount == 4 {
            w = CGFloat(2 * itemSize + padding)
            h = CGFloat(2 * itemSize + padding)
        } else if picCount == 7 {
            h = CGFloat(2 * padding + 3 * itemSize)
            w = CGFloat(3 * itemSize + padding * 2)
        }else {
            let row = picCount / 4
            h = CGFloat(row * padding + (row + 1) * itemSize)
            w = CGFloat(3 * itemSize + padding * 2)
        }
        
        return CGSizeMake(w, h)
    }
    
    func setCell(data: Status) {
        self.status = data
    }

}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension StatusCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.status.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! PictureCell
        cell.url = self.status.pictureURLs![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PictureCell
        delegate?.didSelectedPicture(self, pictureCell: cell!, index: indexPath.row)
    }
}

// MARK: - PictureCell

class PictureCell: UICollectionViewCell {
    
    @IBOutlet var picView: UIImageView!
    
    var url: NSURL? {
        didSet {
            picView.sd_setImageWithURL(url)
        }
    }
    
}
