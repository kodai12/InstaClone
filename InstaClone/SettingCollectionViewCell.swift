//
//  SettingCollectionViewCell.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/17.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    
    func updateUI(){
        
        postImage.layer.cornerRadius = 5.0
        postImage.clipsToBounds = true
        
    }
}
