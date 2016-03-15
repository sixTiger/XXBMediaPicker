//
//  NSIndexSet+Convenience.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

extension NSIndexSet {
    
    func XXB_indexPathsFromIndexesWithSection(section: NSInteger) ->[NSIndexPath]{
        var indexpaths = [NSIndexPath]()
        for (index, _) in self.enumerate() {
            indexpaths.append(NSIndexPath(forRow: index, inSection: section))
        }
        return indexpaths
    }
}

