//
//  Post.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit

class Post {
    // プロパティー
    var id: String
    var userName: String
    var iconImage: UIImage
    var postImage: UIImage!     // 写真がない可能性もある
    var comment: String
    
    
    // ポストIDはポストのデータを習得するときに必要
    
    init(postId: String, userName: String,iconImage: UIImage, postImage: UIImage!, comment: String)
    {
        self.id = postId
        self.userName = userName
        self.iconImage = iconImage
        self.postImage = postImage      // なしでもOK
        self.comment = comment
    }
    
    static let allPost = {
        
    }
    
}
