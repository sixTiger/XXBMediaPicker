//
//  XXBMediaGroupCell.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/1.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public class XXBMediaGroupCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var mediaAsset: XXBMediaAssetDataSouce? {
        didSet {
            if (mediaAsset == nil) {
                return
            }
            let id = 1
            self.mediaID  = mediaAsset!.imageWithSize(CGSizeMake(60, 60), completionHandler: { (image: UIImage?, info) -> Void in
                if id == 1 {
                }
                if Int(self.mediaID!) == self.tag {
                    self.iconImageView.image = image
                }
            })
            self.tag = Int(self.mediaID!)
        }
    }
    private var mediaID: XXBMediaRequestID? = 0
    private lazy var iconImageView: UIImageView = {
        var iconImageView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
        return iconImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        return titleLabel
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor(red: (CGFloat)(arc4random_uniform(255)) / 255.0, green: (CGFloat)(arc4random_uniform(255)) / 255.0, blue: (CGFloat)(arc4random_uniform(255)) / 255.0, alpha: 1.0)
        iconImageView.frame = CGRectMake(2, 1, self.bounds.size.height - 2, self.bounds.size.height - 2)
        titleLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame) + 2, 0, self.bounds.size.width - CGRectGetMaxX(iconImageView.frame) - 2, self.bounds.size.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
