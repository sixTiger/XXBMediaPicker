//
//  XXBMediaGroupCell.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/1.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

class XXBMediaGroupCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor(red: (CGFloat)(arc4random_uniform(255)) / 255.0, green: (CGFloat)(arc4random_uniform(255)) / 255.0, blue: (CGFloat)(arc4random_uniform(255)) / 255.0, alpha: 1.0)
    }

}
