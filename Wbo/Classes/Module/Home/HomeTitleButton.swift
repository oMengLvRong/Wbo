import UIKit

class HomeTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.titleLabel?.text == "首页"{
            return
        }
        titleLabel!.frame = CGRectOffset(titleLabel!.frame, -self.imageView!.frame.size.width, 0)
        imageView!.frame = CGRectOffset(imageView!.frame, titleLabel!.frame.size.width, 0)
    }
}