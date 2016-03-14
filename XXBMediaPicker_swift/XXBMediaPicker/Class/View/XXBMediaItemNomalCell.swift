//
//  XXBMediaItemNomalCell.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/14.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

class XXBMediaItemNomalCell: UICollectionViewCell {
    var mediaAsset: XXBMediaAssetDataSouce? {
        didSet {
            guard ((mediaAsset) != nil) else {
                return
            }
            self.mediaID  = mediaAsset!.imageWithSize(CGSizeMake(60, 60), completionHandler: { (image: UIImage?, info) -> Void in
                if Int(self.mediaID!) == self.tag {
                    self.iconImageView.image = image
                }
            })
            self.tag = Int(self.mediaID!)
        }
    }
    private var mediaID: XXBMediaRequestID? = 0
    private lazy var iconImageView: UIImageView = {
        var iconImageView = UIImageView(frame:self.contentView.bounds)
        return iconImageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor(red: (CGFloat)(arc4random_uniform(255)) / 255.0, green: (CGFloat)(arc4random_uniform(255)) / 255.0, blue: (CGFloat)(arc4random_uniform(255)) / 255.0, alpha: 1.0)
        iconImageView.frame = CGRectMake(2, 1, self.bounds.size.height - 2, self.bounds.size.height - 2)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView .addSubview(iconImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
