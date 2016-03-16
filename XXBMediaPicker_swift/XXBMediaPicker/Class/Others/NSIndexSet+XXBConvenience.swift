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
        for (index, value) in self.enumerate() {
            print("index \(index),value\(value)")
            indexpaths.append(NSIndexPath(forRow:value, inSection: section))
        }
        return indexpaths
    }
}

